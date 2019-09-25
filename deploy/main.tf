resource "aws_kms_key" "www_je_key" {
  description             = "This key is used to encrypt bucket objects"
  deletion_window_in_days = var.s3_kms_delete_window
}

resource "aws_s3_bucket" "www-je-bucket" {
  bucket = var.s3_bucket_name
  acl    = var.s3_policy_acl 
  policy = file(var.s3_policy_www)

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = aws_kms_key.www_je_key.arn
        sse_algorithm     = "aws:kms"
      }
    }
  }

  website {
    index_document = "index.html"
    error_document = "error.html"

    routing_rules = <<EOF
[{
    "Condition": {
        "KeyPrefixEquals": "docs/"
    },
    "Redirect": {
        "ReplaceKeyPrefixWith": "documents/"
    }
}]
EOF
  }
}

# Fix s3 directory sync
#resource "aws_s3_bucket_object" "example" {
#  for_each = fileset(path.module, "my-dir/**/file_*")
#
#  bucket = aws_s3_bucket.example.id
#  key    = replace(each.value, "my-dir", "base_s3_key")
#  source = each.value
#}

#resource "null_resource" "remove_and_upload_to_s3" {
#  provisioner "local-exec" {
#    command = "aws s3 sync ${path.module}/s3Contents s3://${aws_s3_bucket.site.id}"
#  }
#}

