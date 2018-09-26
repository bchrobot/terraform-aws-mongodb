variable "aws_access_key" {}
variable "aws_secret_key" {}

provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "us-east-2"
}

resource "aws_key_pair" "mongodb" {
  key_name   = "mongodb-key"
  public_key = "${file("${path.module}/keys/mongodb.pub")}"
}

resource "aws_security_group" "mongodb" {
  name        = "mongodb"
  description = "Allow all inbound SSH and MongoDB traffic."

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "SSH access"
  }

  ingress {
    from_port   = 27017
    to_port     = 27017
    protocol    = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
    description = "MongoDB access"
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  tags {
    Name = "MongoDB"
  }
}

module "mongodb" {
  source = "../../"

  aws_region        = "us-east-2"
  availability_zone = "us-east-2a"
  instance_type     = "t2.micro"
  volume_size       = "10"
  key_name          = "${aws_key_pair.mongodb.key_name}"
  private_key       = "${file("${path.module}/keys/mongodb")}"
  security_groups   = ["${aws_security_group.mongodb.name}"]
}
