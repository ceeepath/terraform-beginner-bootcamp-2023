variable "user_uuid" {
  type = string
  description = "My Exam-Pro UUID"
  validation {
    condition        = can(regex("^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[1-5][0-9a-fA-F]{3}-[89abAB][0-9a-fA-F]{3}-[0-9a-fA-F]{12}$", var.user_uuid))
    error_message    = "The user_uuid value is not a valid UUID."
  }
}

variable "bucket_name" {
  description = "The name of the S3 bucket"
  type        = string

  validation {
    condition     = (
      length(var.bucket_name) >= 3 && length(var.bucket_name) <= 63 && 
      can(regex("^[a-z0-9][a-z0-9-.]*[a-z0-9]$", var.bucket_name))
    )
    error_message = "The bucket name must be between 3 and 63 characters, start and end with a lowercase letter or number, and can contain only lowercase letters, numbers, hyphens, and dots."
  }
}

variable "website_files" {
  description = "Name of the index and error document for the website"
  type = map(string)
}

variable "file_path" {
  description = "Path of the index and error document for the website"
  type = map(string)

  validation {
  condition = fileexists(var.file_path.index) && fileexists(var.file_path.error)
  error_message = "One or both of the provided file paths do not exist."
  }
}