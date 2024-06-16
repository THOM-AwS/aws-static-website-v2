
########################################################################
# www bucket
resource "aws_s3_bucket" "thiswww" {
  bucket        = lower("www.${var.domain_name}")
  force_destroy = true
  lifecycle {
    prevent_destroy = false
  }
  tags = var.tags
}

resource "aws_s3_bucket_logging" "thiswww" {
  count         = var.create_logging_bucket ? 1 : 0
  bucket        = aws_s3_bucket.thiswww.id
  target_bucket = aws_s3_bucket.log_bucket[count.index].id
  target_prefix = "www"
}

resource "aws_s3_bucket_server_side_encryption_configuration" "thiswww" {
  bucket = aws_s3_bucket.thiswww.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_acl" "thiswww" {
  bucket = aws_s3_bucket.thiswww.id
  acl    = "log-delivery-write"
}

resource "aws_s3_bucket_versioning" "thiswww" {
  bucket = aws_s3_bucket.thiswww.id
  versioning_configuration {
    status = "Disabled"
  }
}

resource "aws_s3_bucket_public_access_block" "thiswww" {
  bucket = aws_s3_bucket.thiswww.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

######################################################################
# log bucket
resource "aws_s3_bucket" "log_bucket" {
  count         = var.create_logging_bucket ? 1 : 0
  bucket        = lower("${var.domain_name}-logging")
  force_destroy = true
  lifecycle {
    prevent_destroy = false
  }
  tags = var.tags
}

resource "aws_s3_bucket_server_side_encryption_configuration" "logging" {
  count  = var.create_logging_bucket ? 1 : 0
  bucket = aws_s3_bucket.log_bucket[count.index].id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_acl" "logging" {
  count  = var.create_logging_bucket ? 1 : 0
  bucket = aws_s3_bucket.log_bucket[count.index].id
  acl    = "private"
}

resource "aws_s3_bucket_policy" "s3_policy_logging" {
  count  = var.create_logging_bucket ? 1 : 0
  bucket = aws_s3_bucket.log_bucket[count.index].bucket

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid : "AllowLogging",
        Effect : "Allow",
        Principal = {
          AWS = "arn:aws:iam::cloudfront:user/CloudFront Origin Access Identity ${aws_cloudfront_origin_access_identity.origin_access_identity.id}"
        },
        Action   = "s3:PutObject",
        Resource = "arn:aws:s3:::${aws_s3_bucket.log_bucket[count.index].bucket}/*"
      }
    ]
  })
}
