# Specify the AWS provider and region for creating resources
provider "aws" {
  region = "eu-central-1"
}

# Creating an S3 bucket to store static content
resource "aws_s3_bucket" "static_bucket" {
  bucket        = "my-static-content-bucket-123456"
  force_destroy = true

# Tags for bucket identification
  tags = {
    Name = "Static Content Bucket"
  }
}

# Uploading index.html file to S3 bucket
resource "aws_s3_object" "index_html" {
  bucket       = aws_s3_bucket.static_bucket.id
  key          = "index.html"
  content      = <<-EOF
    <html>
      <body>
        <h1>Hello World</h1>
      </body>
    </html>
  EOF
  content_type = "text/html"
}

# Create Identity for CloudFront Access to S3 (OAI)
resource "aws_cloudfront_origin_access_identity" "cf_oai" {
  comment = "OAI for Static S3 Bucket"
}

# Set an access policy for the S3 bucket so CloudFront can read its contents
resource "aws_s3_bucket_policy" "s3_policy" {
  bucket = aws_s3_bucket.static_bucket.id
  # Policy allowing CloudFront access via OAI
  policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = {
          AWS = aws_cloudfront_origin_access_identity.cf_oai.iam_arn
        }
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.static_bucket.arn}/*"
      }
    ]
  })
}

# Creating a CloudFront distribution to deliver content from S3
resource "aws_cloudfront_distribution" "cf_distribution" {
  enabled = true

  # Setting up the origin for CloudFront, specifying the S3 bucket
  origin {
    domain_name = aws_s3_bucket.static_bucket.bucket_regional_domain_name
    origin_id   = "S3-Origin"

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.cf_oai.cloudfront_access_identity_path
    }
  }

  # Configuring Caching Behavior for CloudFront
  default_cache_behavior {
    target_origin_id       = "S3-Origin"
    viewer_protocol_policy = "redirect-to-https"
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
  }
  
  # Specify the index file (default root object)
  default_root_object = "index.html"

  # Using CloudFront's standard SSL certificate for HTTPS
  viewer_certificate {
    cloudfront_default_certificate = true
  }

  restrictions {
    geo_restriction {
      restriction_type = "none" # Allow access from any region
    }
  }

  # Tags for CloudFront distribution
  tags = {
    Name = "CloudFront Distribution"
  }
}

resource "aws_s3_bucket_public_access_block" "public_access_block" {
  bucket = aws_s3_bucket.static_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Output the CloudFront distribution URL to access the static site
output "cdn_url" {
  value = aws_cloudfront_distribution.cf_distribution.domain_name # CloudFront URL for access
}



