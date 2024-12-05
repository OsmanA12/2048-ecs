# Ecs cluster

resource "aws_ecs_cluster" "foo" {
  name = "2048-cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

# ECS Task definition

resource "aws_ecs_task_definition" "service" {
  family = "service"
  container_definitions = jsonencode([
    {
      name      = "first"
      image     = "service-first"
      cpu       = 10
      memory    = 512
      essential = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
        }
      ]
    },
    {
      name      = "2048-app"
      image     = var.image_id  
      essential = true
      portMappings = [
        {
          containerPort = 3000
          hostPort      = 3000
        }
      ]
    }
  ])

  volume {
    name      = "service-storage"
    host_path = "/ecs/service-storage"
  }

  placement_constraints {
    type       = "memberOf"
    expression = "attribute:ecs.availability-zone in [eu-west-2a, eu-west-2b]"
  }
}

# ECS Service

resource "aws_ecs_service" "mongo" {
  name            = "mongodb"
  cluster         = aws_ecs_cluster.foo.id
  task_definition = aws_ecs_task_definition.service.id 
  desired_count   = 3
  iam_role        = aws_iam_role.test_role.id 
  depends_on      = [aws_iam_role_policy.test_policy, aws_lb_listener.front_end]

  ordered_placement_strategy {
    type  = "binpack"
    field = "cpu"
  }

  network_configuration {
    assign_public_ip = true
    subnets          = var.subnet_ids 
    security_groups  = [var.security_group_id] 
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.test.id
    container_name   = "2048app-container"
    container_port   = 8080
  }

  placement_constraints {
    type       = "memberOf"
    expression = "attribute:ecs.availability-zone in [eu-west-2a, eu-west-2b]"
  }
} 

# IAM role


resource "aws_iam_role" "test_role" {
 name = "ecs-role"


 # Terraform's "jsonencode" function converts a
 # Terraform expression result to valid JSON syntax.
 assume_role_policy = jsonencode({
   Version = "2012-10-17"
   Statement = [
     {
       Action = "sts:AssumeRole"
       Effect = "Allow"
       Sid    = ""
       Principal = {
         Service = "ecs.amazonaws.com"
       }
     },
   ]
 })


 tags = {
   tag-key = "tag-value"
 }
}


# IAM Role Policy attachment

resource "aws_iam_role_policy" "test_policy" {
  name = "test_policy"
  role = aws_iam_role.test_role.id

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ec2:Describe*",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}



data "aws_iam_policy_document" "policy" {
 statement {
   effect    = "Allow"
   actions   = ["ecs:Describe*"]
   resources = ["*"]
 }
}


resource "aws_iam_policy" "policy" {
 name        = "2048app-policy"
 description = "A test policy"
 policy      = data.aws_iam_policy_document.policy.json
}


resource "aws_iam_role_policy_attachment" "test" {
 role       = aws_iam_role.test_role.id 
 policy_arn = var.policy_arn 
}


