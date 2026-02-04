variable  "project_prefix"  { type  =  string  }
variable "alb_arn"               {  type =  string  }

resource "aws_wafv2_web_acl"  "this"  {
   name               =  "${var.project_prefix}-waf"
   description  =  "Zero-Trust WAF"
    scope            =  "REGIONAL"

   default_action  {
       allow  {}
   }

    rule {
       name         =  "AWS-AWSManagedRulesCommonRuleSet"
       priority  =  1

       override_action {
           none  {}
       }

       statement {
           managed_rule_group_statement  {
              name              =  "AWSManagedRulesCommonRuleSet"
              vendor_name  =  "AWS"
           }
       }

       visibility_config  {
           cloudwatch_metrics_enabled  = true
           metric_name                             =  "common-rules"
          sampled_requests_enabled      = true
       }
    }

   visibility_config  {
       cloudwatch_metrics_enabled  = true
       metric_name                             =  "zt-waf"
       sampled_requests_enabled     =  true
    }
}

resource  "aws_wafv2_web_acl_association"  "alb_assoc" {
    resource_arn  = var.alb_arn
    web_acl_arn   =  aws_wafv2_web_acl.this.arn
}
