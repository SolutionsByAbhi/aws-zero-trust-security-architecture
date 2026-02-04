 output  "alb_dns_name"  {
    value  =  module.zero_trust_proxy.alb_dns_name
 }

 output  "vpc_id"  {
    value  =  module.network.vpc_id
 }
