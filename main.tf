provider "aws" {
  region ="us-east-1" 
  token = var.aws_session_token
  access_key = var.aws_access_key_id
  secret_key = var.aws_secret_access_key
}


