module "tech-challenge-register-confirm-lambda" {
  source = "./modules/generic"

  create_aws_lambda_function = true

  lambda_function_name         = "tech-challenge-register-confirm-lambda"
  lambda_memory_size           = 128
  lambda_timeout               = 30
  lambda_description           = "Lambda function to confirm registrations"
  lambda_image_uri             = var.lambda_image_uri
  lambda_tags                  = local.tags
  lambda_package_type          = "Image"
  lambda_environment           = {}
  lambda_subnet_ids            = []
  lambda_security_group_ids    = []
  lambda_statement_id          = "AllowAPIGatewayInvoke"
  lambda_principal             = "apigateway.amazonaws.com"
  integration_type             = "ApiGateway"
  lambda_batch_size            = 1
  create_aws_lambda_permission = true

  ###############################################
  #
  #       CONFIGURATION ECR REPOSITORY
  #
  ###############################################

  create_aws_ecr_repository = true

  ###############################################
  #
  #       CONFIGURATION API GATEWAY
  #
  ###############################################
  api_gateway_name               = "api-tech-challenge-register-lambda"
  api_gateway_description        = "API Gateway to register lambda functions"
  api_gateway_resource_path_part = "confirm"
  api_gateway_http_method        = "POST"
  api_gateway_stage_name         = "production"
  api_gateway_authorization      = "NONE"
  integration_api_http_method    = "POST"
  integration_api_type           = "AWS_PROXY"
  create_api_gateway             = true
}


