output "function_arn" {
  description = "The ARN of the Lambda@Edge function"
  value       = aws_lambda_function.lambda_edge.arn
}
