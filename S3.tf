
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

resource "aws_s3_bucket_policy" "thiswww" {
  bucket = aws_s3_bucket.thiswww.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid    = "PublicReadGetObject",
        Effect = "Allow",
        Principal = {
          AWS = "${aws_cloudfront_origin_access_identity.origin_access_identity.iam_arn}"
        },
        Action   = "s3:GetObject",
        Resource = "arn:aws:s3:::${aws_s3_bucket.thiswww.id}/*"
      }
    ]
  })
}

resource "aws_s3_bucket_website_configuration" "thiswww" {
  bucket = aws_s3_bucket.thiswww.id
  index_document {
    suffix = "index.html"
  }
  error_document {
    key = "index.html"
  }
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

resource "aws_s3_bucket_ownership_controls" "ownership_controls_config_bucket" {
  count  = var.create_logging_bucket ? 1 : 0
  bucket = aws_s3_bucket.log_bucket[count.index].bucket

  rule {
    object_ownership = "ObjectWriter"
  }
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
          AWS = aws_cloudfront_origin_access_identity.origin_access_identity.iam_arn
        },
        Action   = "s3:PutObject",
        Resource = "arn:aws:s3:::${aws_s3_bucket.log_bucket[count.index].bucket}/*"
      }
    ]
  })
}
