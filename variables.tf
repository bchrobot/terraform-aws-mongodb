variable "availability_zone" {
  type        = "string"
  description = "AWS Availability Zone to create the DB in."
  default     = "us-east-1a"
}

variable "instance_type" {
  type        = "string"
  description = "The AWS EC2 tier to use for the DB instances."
  default     = "t2.large"
}

variable "volume_size" {
  type        = "string"
  description = "Size of the DB storage volume."
  default     = "100"
}

variable "security_groups" {
  type        = "list"
  description = "List of security group names."
  default     = []
}

variable "key_name" {
  type        = "string"
  description = "Name of the key pair to provision the instance with."
}

variable "private_key" {
  type        = "string"
  description = "Private key contents."
}
