module "alb" {
  source            = "./modules/alb"
  alb_name          = "2048-alb"
  security_group_id = module.vpc.security_group_id                  # Output from VPC module
  subnet_ids        = [module.vpc.subnet_a_id, module.vpc.subnet_b_id] # Output from VPC module
  vpc_id            = module.vpc.vpc_id                             # Output from VPC module
}


module "ecs" {
  source            = "./modules/ecs"
  security_group_id = module.vpc.security_group_id                  # Output from VPC module
  subnet_ids        = [module.vpc.subnet_a_id, module.vpc.subnet_b_id] # Output from VPC module
  target_group_arn    = module.alb.target_group_arn                 # Output from ALB module
  http_lb_listener    = module.alb.http_listener                   # Output from ALB module
  https_lb_listener   = module.alb.https_listener                   # Output from ALB module
}

module "route53" {
  source = "./modules/route53"
  a_record_name = "osman2048.com"
  alb_dns_name = module.alb.alb_dns_name
}


module "vpc" {
  source = "./modules/vpc"
}