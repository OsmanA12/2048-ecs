# VPC


resource "aws_vpc" "main" {
 tags = {
   Name = var.vpc_name 
 }
 cidr_block = "10.0.0.0/16"
} 

# Subnet


resource "aws_subnet" "main" {
 vpc_id     = aws_vpc.main.id
 cidr_block = "10.0.1.0/24"
 availability_zone = var.availability_zone_a 


 tags = {
   Name = "ecs-subnet"
 }
}

#Subnet 2

resource "aws_subnet" "main2" {
 vpc_id     = aws_vpc.main.id
 cidr_block = "10.0.2.0/24"
 availability_zone = var.availability_zone_b 


 tags = {
   Name = "ecs-subnet2"
 }
}

# Security group
resource "aws_security_group" "default" {
 name   = var.security_group_name    
 vpc_id = aws_vpc.main.id


 ingress {
   from_port   = 80
   to_port     = 80
   protocol    = "tcp"
   cidr_blocks = ["0.0.0.0/0"]
 }


 ingress {
   from_port   = 3000
   to_port     = 3000
   protocol    = "tcp"
   cidr_blocks = ["0.0.0.0/0"]
 }


 ingress {
   from_port   = 443
   to_port     = 443
   protocol    = "tcp"
   cidr_blocks = ["0.0.0.0/0"]
 }


 egress {
   from_port   = 0
   to_port     = 0
   protocol    = "-1"
   cidr_blocks = ["0.0.0.0/0"]
 }
}

#Internet gateway


resource "aws_internet_gateway" "gw" {
 vpc_id = aws_vpc.main.id


 tags = {
   Name = var.internet_gateway_name 
 }
}


# Internet gateway egress


resource "aws_egress_only_internet_gateway" "example" {
 vpc_id = aws_vpc.main.id


 tags = {
   Name = var.egress_internet_gateway_name 
 }
}


# route table


resource "aws_route_table" "example" {
 vpc_id = aws_vpc.main.id


 route {
   cidr_block = "0.0.0.0/0"
   gateway_id = aws_internet_gateway.gw.id
 }


 route {
   ipv6_cidr_block        = "::/0"
   egress_only_gateway_id = aws_egress_only_internet_gateway.example.id
 }


 tags = {
   Name = "example"
 }
}


# Route table for subnet


resource "aws_route_table_association" "a" {
 subnet_id      = aws_subnet.main.id
 route_table_id = aws_route_table.example.id
}


resource "aws_route_table_association" "b" {
 subnet_id      = aws_subnet.main2.id
 route_table_id = aws_route_table.example.id
}


