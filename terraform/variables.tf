variable "aws_region" {
  default = "ap-south-1"
}

variable "ami_id" {
  description = "Ubuntu 22.04 AMI ID for ap-south-1"
  default     = "ami-0388e3ada3d9812da" # Replace with latest if needed
}

variable "key_name" {
  description = "Name of the AWS Key Pair"
  default     = "healthroute-key" 
}

