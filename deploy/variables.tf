variable aws_region {
  type = string
  default = "us-west-2"
}

variable s3_bucket_name {
  type = string
}

variable s3_kms_delete_window {
  type    = number
  default = 7
}

variable s3_policy_acl {
  type    = string
  default = "private"
}

variable s3_policy_www {
  type = string
}
