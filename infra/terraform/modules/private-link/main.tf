variable "project_prefix"  {  type  =  string }
variable  "vpc_id"                {  type  =  string }
variable  "nlb_arn"              {  type  =  string  }

resource  "aws_vpc_endpoint_service"  "this"  {
   acceptance_required  =  true
   network_load_balancer_arns  =  [var.nlb_arn]

    allowed_principals  = [
       "arn:aws:iam::123456789012:root"  #  replace  with  consumer accounts
    ]
}

output  "endpoint_service_name"  {
   value  =  aws_vpc_endpoint_service.this.service_name
}
