#Enable AWS authentication
resource "vault_auth_backend" "aws" {
  type = "aws"
  description = "AWS authentication"
}

resource "vault_aws_auth_backend_client" "backend_client" {
  backend      = vault_auth_backend.aws.path
  sts_region   = "ap-southeast-1"
  sts_endpoint = "https://sts.ap-southeast-1.amazonaws.com"
}

resource "vault_mount" "kv" {
  path        = "lambda"
  type        = "kv"
  options     = { version = "2" }
  description = "KV Version 2 secret engine mount"
}


resource "vault_aws_auth_backend_role" "vault_lambda_role" {
  backend                  = vault_auth_backend.aws.path
  role                     = "vault-lambda-role"
  auth_type                = "iam"
  resolve_aws_unique_ids   = false
  bound_iam_principal_arns = [module.lambda_execution_role.iam_role_arn]
  token_policies           = [vault_policy.vault_policy_for_lambda.name]
}


resource "vault_policy" "vault_policy_for_lambda" {
  name   = "vault-lambda"
  policy = data.vault_policy_document.read_lambda_api_keys.hcl
}

data "vault_policy_document" "read_lambda_api_keys" {
  rule {
    path         = "lambda/data/api_keys"
    capabilities = ["read"]
    description  = "Read all api keys in lambda/api_keys "
  }
}
