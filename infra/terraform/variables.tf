variable  "region"  {
   type               =  string
   description  =  "AWS region"
    default         =  "us-east-1"
}

variable  "project_prefix"  {
   type              =  string
    description =  "Prefix  for  resource  names"
   default         =  "zt-demo"
}

variable  "internal_api_image"  {
   type               = string
    description  = "ECR  image  URI  for  internal API"
}
