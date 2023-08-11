module "lambda_function" {
  source  = "terraform-aws-modules/lambda/aws"
  version = "~>5.3"

  function_name         = "vault-lambda-function"
  handler               = "index.handler"
  source_path           = "./handler"
  runtime               = "nodejs18.x"
  memory_size           = "128"
  create_role           = false
  lambda_role           = module.lambda_execution_role.iam_role_arn

  environment_variables = {
    VAULT_ADDR                = "http://13.229.130.210:8200"
    VAULT_AUTH_PROVIDER       = "aws"
    VAULT_AUTH_ROLE           = module.lambda_execution_role.iam_role_name #Use the same name as the Lambda role name
    VAULT_STS_ENDPOINT_REGION = "ap-southeast-1"
    VAULT_SECRET_PATH         = "lambda/data/api_keys"
    VAULT_PROXY_SERVER_HOST   =  "http://127.0.0.1:8200"
    VAULT_API_VERSION         = "v1"
  }

  layers = ["arn:aws:lambda:ap-southeast-1:634166935893:layer:vault-lambda-extension:16"]
}