module "vpc" {
  source = "./modules/vpc"
  vpc_cidr = var.vpc_cidr
  pub_subnet_cidr = var.pub_subnet_cidr
  pri_subnet_cidr = var.pri_subnet_cidr
}

module "sg" {
    source = "./modules/sg"
    vpc_id = module.vpc.vpc_id
}

module "ec2" {
  source = "./modules/ec2"
  sg_id = module.sg.sg_pri_id
  subnets = module.vpc.pri_subnet_ids
}

module "alb" {
  source = "./modules/alb"
  sg_id = module.sg.sg_alb_id
  subnets = module.vpc.pub_subnet_ids
  vpc_id = module.vpc.vpc_id
  instances = module.ec2.instances
}