variable "project_prefix"  {  type  =  string }

resource  "aws_iam_role"  "auth_lambda_role" {
    name                           =  "${var.project_prefix}-auth-lambda-role"
   assume_role_policy  =  data.aws_iam_policy_document.lambda_assume.json
}

data  "aws_iam_policy_document"  "lambda_assume" {
    statement  {
       actions =  ["sts:AssumeRole"]
       principals  {
           type              =  "Service"
          identifiers  =  ["lambda.amazonaws.com"]
       }
   }
}

resource  "aws_iam_role_policy_attachment" "lambda_basic"  {
    role            =  aws_iam_role.auth_lambda_role.name
   policy_arn  =  "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource  "aws_lambda_function"  "auth_proxy"  {
   function_name  =  "${var.project_prefix}-auth-proxy"
   role                  =  aws_iam_role.auth_lambda_role.arn
   handler             =  "handler.lambda_handler"
   runtime             =  "python3.11"
   filename           =  "${path.module}/../../../lambdas/auth-proxy/dist/auth-proxy.zip"
   timeout             = 10
}

output  "auth_lambda_arn" {
    value  = aws_lambda_function.auth_proxy.arn
}
