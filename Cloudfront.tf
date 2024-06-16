resource "aws_cloudfront_distribution" "this" {
  depends_on = [
    aws_s3_bucket.thiswww,
    aws_s3_bucket.log_bucket
  ]

  origin {
    domain_name = "www.${var.domain_name}.s3.amazonaws.com"
    origin_id   = "www.${var.domain_name}-origin"

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "${var.domain_name} Origin."
  default_root_object = "index.html"

  logging_config {
    include_cookies = true
    bucket          = "${lower("${var.domain_name}-logging")}.s3.amazonaws.com"
    prefix          = "cloudfront-logs"
  }

  aliases = [
    "www.${var.domain_name}",
    var.domain_name
  ]

  default_cache_behavior {
    target_origin_id       = "www.${var.domain_name}-origin"
    viewer_protocol_policy = "redirect-to-https"

    allowed_methods = ["GET", "HEAD", "OPTIONS"]
    cached_methods  = ["GET", "HEAD", "OPTIONS"]

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    lambda_function_association {
      event_type   = "origin-response"
      lambda_arn   = aws_lambda_function.cloudfront_lambda.qualified_arn
      include_body = false
    }
  }

  custom_error_response {
    error_code            = 403
    response_code         = 200
    error_caching_min_ttl = 0
    response_page_path    = "/index.html"
  }

  price_class = "PriceClass_100"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn      = data.aws_acm_certificate.this.arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }

  wait_for_deployment = true
  tags                = var.tags
}

resource "aws_cloudfront_origin_access_identity" "origin_access_identity" {
  comment = "access-identity-${var.domain_name}.s3.amazonaws.com"
}

data "aws_cloudfront_origin_request_policy" "this" {
  name = "Managed-CORS-S3Origin"
}

data "aws_cloudfront_cache_policy" "this" {
  name = "Managed-CachingOptimized"
}
