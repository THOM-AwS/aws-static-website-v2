data "aws_route53_zone" "selected" {
  name         = "${var.domain_name}."
  private_zone = false
}

data "aws_route53_record" "existing_record" {
  zone_id = data.aws_route53_zone.selected.zone_id
  name    = var.domain_name
}

resource "aws_route53_record" "www" { # www subdomain bucket
  zone_id = aws_route53_zone.selected.zone_id
  name    = "www.${var.domain_name}"
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.this.domain_name
    zone_id                = aws_cloudfront_distribution.this.hosted_zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "this" { # base domain
  zone_id = data.aws_route53_zone.selected.zone_id
  name    = var.domain_name
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.this.domain_name
    zone_id                = aws_cloudfront_distribution.this.hosted_zone_id
    evaluate_target_health = true
  }
}
