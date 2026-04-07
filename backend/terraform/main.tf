terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    archive = {
      source  = "hashicorp/archive"
      version = "~> 2.4"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "${path.module}/../src/handlers/health.py"
  output_path = "${path.module}/../health.zip"
}


data "archive_file" "progress_zip" {
  type        = "zip"
  source_file = "${path.module}/../src/handlers/progress.py"
  output_path = "${path.module}/../progress.zip"
}
resource "aws_iam_role" "lambda_exec" {
  name = "${var.project_name}-${var.environment}-lambda-exec-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
  tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}

resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_lambda_function" "health_check" {
  function_name    = "${var.project_name}-${var.environment}-health-check"
  role             = aws_iam_role.lambda_exec.arn
  handler          = "health.lambda_handler"
  runtime          = "python3.12"
  filename         = data.archive_file.lambda_zip.output_path
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
  timeout          = 10

}

resource "aws_lambda_function" "progress" {
  function_name = "${var.project_name}-${var.environment}-progress"
  role          = aws_iam_role.lambda_exec.arn
  handler       = "progress.lambda_handler"
  runtime       = "python3.12"

  filename         = data.archive_file.progress_zip.output_path
  source_code_hash = data.archive_file.progress_zip.output_base64sha256
  timeout          = 10

  environment {
    variables = {
      PROGRESS_TABLE = aws_dynamodb_table.progress.name
    }
  }
}
resource "aws_apigatewayv2_api" "starwords_api" {
  name          = "${var.project_name}-${var.environment}-api"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_integration" "health_lambda" {
  api_id                 = aws_apigatewayv2_api.starwords_api.id
  integration_type       = "AWS_PROXY"
  integration_uri        = aws_lambda_function.health_check.invoke_arn
  integration_method     = "POST"
  payload_format_version = "2.0"

}

resource "aws_apigatewayv2_integration" "progress_lambda" {
  api_id                 = aws_apigatewayv2_api.starwords_api.id
  integration_type       = "AWS_PROXY"
  integration_uri        = aws_lambda_function.progress.invoke_arn
  integration_method     = "POST"
  payload_format_version = "2.0"
}

resource "aws_apigatewayv2_route" "health_get" {
  api_id    = aws_apigatewayv2_api.starwords_api.id
  route_key = "GET /health"
  target    = "integrations/${aws_apigatewayv2_integration.health_lambda.id}"
}


resource "aws_apigatewayv2_route" "progress_post" {
  api_id    = aws_apigatewayv2_api.starwords_api.id
  route_key = "POST /progress"
  target    = "integrations/${aws_apigatewayv2_integration.progress_lambda.id}"
}

resource "aws_apigatewayv2_stage" "default" {
  api_id      = aws_apigatewayv2_api.starwords_api.id
  name        = "$default"
  auto_deploy = true
}

resource "aws_lambda_permission" "allow_apigw" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.health_check.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.starwords_api.execution_arn}/*/*"
}

resource "aws_lambda_permission" "allow_apigw_progress" {
  statement_id  = "AllowAPIGatewayInvokeProgress"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.progress.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.starwords_api.execution_arn}/*/*"
}

resource "aws_dynamodb_table" "progress" {
  name         = "${var.project_name}-${var.environment}-progress"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "userId"
  range_key    = "lessonId"

  attribute {
    name = "userId"
    type = "S"
  }

  attribute {
    name = "lessonId"
    type = "S"
  }

  tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}

resource "aws_iam_role_policy" "lambda_dynamodb_policy" {
  name = "${var.project_name}-${var.environment}-lambda-dynamodb-policy"
  role = aws_iam_role.lambda_exec.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "dynamodb:PutItem",
          "dynamodb:GetItem",
          "dynamodb:UpdateItem"
        ]
        Resource = aws_dynamodb_table.progress.arn
      }
    ]
  })
}

