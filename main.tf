module "network" {
  source   = "./modules/network"
  vpc_cidr = var.projeto_vpc_cidr
}

module "compute" {
  source     = "./modules/compute"
  vpc_id     = module.network.vpc_id
  subnet_ids = module.network.subnet_ids
}
