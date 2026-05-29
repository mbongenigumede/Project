variable "aws_region" {
  description = "AWS Region"
  type        = string
  default     = "us-east-1"
}

variable "allowed_ssh_ip" {
  description = "Allowed IP for SSH"
  type        = string
}

variable "vpc_cidr" {
  description = "VPC CIDR Block"
  type        = string
  default     = "10.0.0.0/24"
}

variable "public_subnet_cidr" {
  description = "Public Subnet CIDR"
  type        = string
  default     = "10.0.0.0/28"
}

variable "availability_zone" {
  description = "Availability Zone"
  type        = string
  default     = "us-east-1a"
}

variable "instance_type" {
  description = "EC2 Instance Type"
  type        = string
  default     = "t3.micro"
}

variable "ami_id" {
  description = "Amazon Linux 2 AMI"
  type        = string
  default     = "ami-0c02fb55956c7d316"
}

variable "project_name" {
  description = "Project name used for consistent resource naming and tagging"
  type        = string
  default     = "hello-world"
}

variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "dev"
}

variable "owner" {
  description = "Owner name or team — used in resource tags for billing and accountability"
  type        = string
  default     = "mbongeni-gumede"
}

variable "cost_centre" {
  description = "Cost centre or billing code for AWS cost allocation tags"
  type        = string
  default     = "personal"
}
