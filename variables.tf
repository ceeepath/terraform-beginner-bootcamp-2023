variable "teacherseat_user_uuid" {
  type        = string
  description = "My Exam-Pro UUID"
}

variable "bucket_name" {
  description = "The name of the S3 bucket"
  type        = string
}

variable "terratowns_endpoint" {
  description = "The endpoint URL of our Terratowns cloud"
  type = string
}

variable "terratowns_access_token" {
 type = string
}

variable "football_manager" {
  type = object({
    public_path = string
    content_version = number
  })
}

variable "terraform" {
  type = object({
    public_path = string
    content_version = number
  })
}