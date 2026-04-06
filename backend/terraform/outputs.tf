output "api_base_url" {
  value = aws_apigatewayv2_api.starwords_api.api_endpoint
}

output "health_url" {
  value = "${aws_apigatewayv2_api.starwords_api.api_endpoint}/health"
}

output "lambda_function_name" {
  value = aws_lambda_function.health_check.function_name
}

