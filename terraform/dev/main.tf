terraform {
  required_version = ">= 1.4"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# S3 bucket for Starwords DEV
resource "aws_s3_bucket" "starwords_dev" {
  bucket = var.bucket_name

  tags = {
    Project     = "Starwords"
    Environment = "dev"
    ManagedBy   = "terraform"
  }
}

# Recommended: keep bucket private by default
resource "aws_s3_bucket_public_access_block" "starwords_dev" {
  bucket                  = aws_s3_bucket.starwords_dev.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Optional: versioning (nice for safety)
resource "aws_s3_bucket_versioning" "starwords_dev" {
  bucket = aws_s3_bucket.starwords_dev.id

  versioning_configuration {
    status = "Enabled"
  }
}
# ---- CloudFront (DEV) ----

# Origin Access Control (modern replacement for OAI)
resource "aws_cloudfront_origin_access_control" "starwords_dev" {
  name                              = "starwords-dev-oac"
  description                       = "OAC for Starwords DEV bucket"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_distribution" "starwords_dev" {
  enabled             = true
  comment             = "Starwords DEV"
  default_root_object = "index.html"
  price_class         = "PriceClass_100" # cheapest regions

  origin {
    domain_name              = aws_s3_bucket.starwords_dev.bucket_regional_domain_name
    origin_id                = "starwords-dev-s3-origin"
    origin_access_control_id = aws_cloudfront_origin_access_control.starwords_dev.id
  }

  default_cache_behavior {
    target_origin_id       = "starwords-dev-s3-origin"
    viewer_protocol_policy = "redirect-to-https"

    allowed_methods = ["GET", "HEAD", "OPTIONS"]
    cached_methods  = ["GET", "HEAD", "OPTIONS"]

    forwarded_values {
      query_string = true
      cookies {
        forward = "none"
      }
    }

    min_ttl     = 0
    default_ttl = 3600
    max_ttl     = 86400
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}

# Allow ONLY this CloudFront distribution to read from the private bucket
data "aws_iam_policy_document" "starwords_dev_bucket_policy" {
  statement {
    sid = "AllowCloudFrontReadOnly"

    actions = [
      "s3:GetObject"
    ]

    resources = [
      "${aws_s3_bucket.starwords_dev.arn}/*"
    ]

    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"
      values   = [aws_cloudfront_distribution.starwords_dev.arn]
    }
  }
}

resource "aws_s3_bucket_policy" "starwords_dev" {
  bucket = aws_s3_bucket.starwords_dev.id
  policy = data.aws_iam_policy_document.starwords_dev_bucket_policy.json
}
