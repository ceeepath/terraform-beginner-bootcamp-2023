variable "teacherseat_user_uuid" {
  type        = string
  description = "My Exam-Pro UUID"
}

variable "bucket_name" {
  description = "The name of the S3 bucket"
  type        = string
}

variable "website_files" {
  description = "Name of the index and error document for the website"
  type        = map(string)
}

variable "file_path" {
  description = "Path of the index and error document for the website"
  type        = map(string)
}

variable "content_version" {
  description = "The content version. Should be a positive integer starting at 1."
  type        = number
}

variable "assets_path" {
  description = "Path to assets folder"
  type        = string
}

variable "terratowns_endpoint" {
  description = "The endpoint URL of our Terratowns cloud"
  type = string
}

variable "terratowns_access_token" {
 type = string
}