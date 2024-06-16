resource "aws_lambda_function" "cloudfront_lambda" {
  filename         = var.lambda_zip_path
  function_name    = "cloudfront_website_lambda_${var.domain_name}"
  role             = aws_iam_role.lambda_edge.arn
  handler          = "secheader.lambda_handler"
  runtime          = "python3.8"
  publish          = true
  source_code_hash = filebase64sha256(var.lambda_zip_path)

  tags = var.tags
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


resource "null_resource" "zip_lambda_sec" {
  triggers = {
    lambda_hash = filemd5(secheaders.py)
  }
  provisioner "local-exec" {
    command = <<EOT
      apk update && apk add zip
      if command -v zip > /dev/null; then
        zip -r secheaders.zip . -i secheaders.py
      else
        echo "Failed to install zip utility"
        exit 1
      fi
    EOT
  }
}
