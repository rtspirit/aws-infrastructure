#Amazon S3 Bucket

locals {
  force_destroy           = true
  acl                     = "private"
  sse_algorithm           = "aws:kms"
  storage_class           = "STANDARD_IA"
  block_public_acls       = true
  block_public_policy     = true
  restrict_public_buckets = true
  ignore_public_acls      = true
}
resource "random_string" "suffix" {
  length  = 10
  upper   = false
  lower   = true
  special = false
}

resource "aws_s3_bucket_public_access_block" "blockAccess" {
  bucket                  = aws_s3_bucket.csye6225-bucket.id
  block_public_acls       = local.block_public_acls
  block_public_policy     = local.block_public_policy
  restrict_public_buckets = local.restrict_public_buckets
  ignore_public_acls      = local.ignore_public_acls
}


resource "aws_s3_bucket" "csye6225-bucket" {
  bucket        = var.bucket
  acl           = local.acl
  force_destroy = local.force_destroy
  versioning {
    enabled = true
  }
  tags = {
    Name        = "csye6225 s3 Bucket"
    Environment = "DEV"
  }


  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = local.sse_algorithm
      }
    }
  }

  lifecycle_rule {
    enabled = true

    transition {
      days          = 30
      storage_class = local.storage_class
    }
    expiration {
      days = 90
    }
  }
}

resource "aws_s3_bucket" "serverless_bucket" {
  bucket = var.serverless_bucket
  acl = "private"
  force_destroy = true
  lifecycle_rule {
    id = "log"
    enabled = true
    prefix = "log/"
    tags = {
    rule = "log"
    autoclean = "true"
    }
    transition {
    days = 30
    storage_class = "STANDARD_IA"
    }
}
}