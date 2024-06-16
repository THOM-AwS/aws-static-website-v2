# aws-static-website-v2
Static AWS website with S3 acm r53 and cf that is extensible with security

Deploy a static s3 website without the need to use a web server. This module sets up the ability to customise headers and the Content Security policies, as well as other security features.

## Usage

setup a folder in your base directory called `lambda_package_source`, and add your python code for your headers and security policies in there. 

```hcl
module "website" {
  source                = "github.com/THOM-AwS/aws-static-website-v2"
  domain_name           = "example.com"
  create_logging_bucket = true
  tags = {
    Environment = "prod"
  }
}
```