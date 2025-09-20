# variables_template.tf
variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-west-2"

  validation {
    condition     = contains(["us-east-1","us-east-2","us-west-1","us-west-2","ap-south-1","eu-west-1"], var.aws_region)
    error_message = "Set a supported AWS region (example: us-west-2, ap-south-1)."
  }
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"

  validation {
    condition     = can(regex("^t[2-4]\\..+", var.instance_type))
    error_message = "instance_type should be a T-class instance (eg. t3.micro)."
  }
}

variable "key_name" {
  description = "Existing EC2 key pair name (optional, for SSH). Leave empty for none."
  type        = string
  default     = ""
}

variable "ami_id" {
  description = "AMI id (region-specific) - override if needed"
  type        = string
  default     = ""
}

# Container images (can keep defaults or override in tfvars)
variable "frontend_image" {
  type    = string
  default = "noizy23yo/multiverse-terraform:fe_v2"
}
variable "user_image" {
  type    = string
  default = "noizy23yo/multiverse-terraform:user_service_v1"
}
variable "product_image" {
  type    = string
  default = "noizy23yo/multiverse-terraform:product_service_v1"
}
variable "order_image" {
  type    = string
  default = "noizy23yo/multiverse-terraform:order_service_v1"
}
variable "cart_image" {
  type    = string
  default = "noizy23yo/multiverse-terraform:cart_service_v1"
}

# --- Sensitive values: DO NOT put defaults here, supply via terraform.tfvars (ignored) or env ---
variable "atlas_user_uri" {
  description = "MongoDB Atlas connection string for user DB"
  type        = string
  sensitive   = true
}

variable "atlas_product_uri" {
  description = "MongoDB Atlas connection string for product DB"
  type        = string
  sensitive   = true
}

variable "atlas_cart_uri" {
  description = "MongoDB Atlas connection string for cart DB"
  type        = string
  sensitive   = true
}

variable "atlas_order_uri" {
  description = "MongoDB Atlas connection string for order DB"
  type        = string
  sensitive   = true
}

variable "jwt_secret" {
  description = "JWT secret for user service"
  type        = string
  sensitive   = true
}
