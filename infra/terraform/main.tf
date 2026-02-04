module  "network" {
    source              =  "./modules/network"
   project_prefix  =  var.project_prefix
}

module  "iam_zero_trust"  {
   source                 = "./modules/iam-zero-trust"
    project_prefix  = var.project_prefix
}

module  "vpc_lattice" {
    source                =  "./modules/vpc-lattice"
   project_prefix  =  var.project_prefix
   vpc_id                =  module.network.vpc_id
    subnet_ids         = module.network.private_subnet_ids
}

module  "zero_trust_proxy" {
    source                =  "./modules/zero-trust-proxy"
   project_prefix  =  var.project_prefix
   vpc_id                =  module.network.vpc_id
    public_subnet_ids   =  module.network.public_subnet_ids
   private_subnet_ids  =  module.network.private_subnet_ids
   auth_lambda_arn        = module.iam_zero_trust.auth_lambda_arn
}

module  "waf" {
    source                =  "./modules/waf"
   project_prefix  =  var.project_prefix
   alb_arn               = module.zero_trust_proxy.alb_arn
}

module  "private_link" {
    source                =  "./modules/private-link"
   project_prefix  =  var.project_prefix
   vpc_id                =  module.network.vpc_id
    nlb_arn              =  module.zero_trust_proxy.nlb_arn
}

module  "guardduty"  {
   source  =  "./modules/guardduty"
}

module  "security_hub"  {
   source  =  "./modules/security-hub"
}
