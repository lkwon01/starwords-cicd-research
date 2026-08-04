variable "project_name" {
  description = "Project name for tagging resources"
  type        = string
}
variable "environment" {
  description = "Deployment environment (e.g., dev, staging, prod)"
  type        = string
}
variable "aws_region" {
  description = "The AWS region to deploy resources in"
  type        = string
  default     = "us-east-1"
}
