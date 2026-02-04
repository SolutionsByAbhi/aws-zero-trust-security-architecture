variable "project_prefix"             {  type  = string  }
variable  "vpc_id"                           {  type =  string  }
variable  "public_subnet_ids"       {  type =  list(string)  }
variable  "private_subnet_ids"     {  type  = list(string)  }
variable  "auth_lambda_arn"           { type  =  string  }

resource  "aws_security_group"  "alb_sg"  {
   name               = "${var.project_prefix}-alb-sg"
    description  = "ALB  SG"
    vpc_id          =  var.vpc_id

   ingress  {
       from_port      = 443
       to_port         =  443
       protocol       =  "tcp"
       cidr_blocks  =  ["0.0.0.0/0"]
   }

   egress  {
       from_port      = 0
       to_port         =  0
       protocol       =  "-1"
       cidr_blocks  =  ["0.0.0.0/0"]
   }
}

resource "aws_lb"  "alb"  {
   name                           =  "${var.project_prefix}-alb"
    internal                   =  false
    load_balancer_type =  "application"
    security_groups       =  [aws_security_group.alb_sg.id]
   subnets                      = var.public_subnet_ids
}

resource  "aws_lb_target_group" "internal_api_tg"  {
    name         = "${var.project_prefix}-internal-api-tg"
    port         =  80
   protocol  =  "HTTP"
   vpc_id     =  var.vpc_id
    target_type =  "ip"
}

resource "aws_lb_listener"  "https"  {
   load_balancer_arn  =  aws_lb.alb.arn
   port                          = 443
    protocol                  =  "HTTPS"
   ssl_policy              =  "ELBSecurityPolicy-2016-08"
    certificate_arn     =  "arn:aws:acm:REGION:ACCOUNT:certificate/EXAMPLE"  # replace

    default_action {
       type  =  "forward"
       target_group_arn  =  aws_lb_target_group.internal_api_tg.arn
   }
}

#  Optional:  NLB  for  PrivateLink exposure
resource  "aws_lb"  "nlb"  {
   name                           =  "${var.project_prefix}-nlb"
   internal                    =  true
   load_balancer_type  =  "network"
   subnets                      =  var.private_subnet_ids
}

output  "alb_arn"  {
   value  =  aws_lb.alb.arn
}

output  "alb_dns_name"  {
   value  =  aws_lb.alb.dns_name
}

output  "nlb_arn"  {
   value  =  aws_lb.nlb.arn
}
