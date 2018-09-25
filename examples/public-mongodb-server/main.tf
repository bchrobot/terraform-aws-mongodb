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

module "mongodb" {
  source = "../../"

  instance_type = "t2.micro"
  volume_size   = "10"
  key_name      = "${aws_key_pair.mongodb.name}"
  private_key   = "${file("${path.module}/keys/mongodb.pem")}"
}
