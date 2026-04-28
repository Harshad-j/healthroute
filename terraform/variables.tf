variable "aws_region" {
  default = "us-east-1"
}

variable "ami_id" {
  description = "Ubuntu 22.04 AMI ID for us-east-1"
  default     = "ami-0c7217cdde317cfec" # Replace with latest if needed
}

variable "key_name" {
  description = "Name of the AWS Key Pair"
}
