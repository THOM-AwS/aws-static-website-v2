resource "aws_lambda_function" "cloudfront_lambda" {
  filename         = var.lambda_zip_path
  function_name    = "website_security_headers_${local.name_prefix}"
  role             = aws_iam_role.lambda_edge.arn
  handler          = "secheaders.lambda_handler"
  runtime          = "python3.8"
  publish          = true
  source_code_hash = filebase64sha256(var.lambda_zip_path)
  tags             = var.tags
}

data "archive_file" "lambda_zip" {
  type        = "zip"
  source_dir  = var.lambda_zip_path
  output_path = "secheaders.zip"
}

# Extract the first part of the domain name for the function name
locals {
  domain_name_parts = split(".", var.domain_name)
  name_prefix       = element(local.domain_name_parts, 0)
}

resource "aws_iam_role" "lambda_edge" {
  name = "lambda_edge_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      },
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "edgelambda.amazonaws.com"
        }
      }
    ]
  })
  tags = var.tags
}

resource "aws_iam_role_policy" "lambda_edge_policy" {
  role = aws_iam_role.lambda_edge.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Effect   = "Allow",
        Resource = "*"
      }
    ]
  })
}
