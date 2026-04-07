output "api_base_url" {
  value = aws_apigatewayv2_api.starwords_api.api_endpoint
}

output "health_url" {
  value = "${aws_apigatewayv2_api.starwords_api.api_endpoint}/health"
}

output "lambda_function_name" {
  value = aws_lambda_function.health_check.function_name
}

output "progress_url" {
  value = "${aws_apigatewayv2_api.starwords_api.api_endpoint}/progress"
}

output "progress_lambda_name" {
  value = aws_lambda_function.progress.function_name
}

output "progress_table_name" {
  value = aws_dynamodb_table.progress.name
}

output "progress_table_arn" {
  value = aws_dynamodb_table.progress.arn
}
