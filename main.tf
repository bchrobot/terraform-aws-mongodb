data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu*hardy*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "mongodb_one" {
  availability_zone = "${var.availability_zone}"

  tags {
    Name = "mongodb"
  }

  ami           = "${data.aws_ami.ubuntu.id}"
  instance_type = "${var.instance_type}"

  root_block_device {
    volume_type = "gp2"
    volume_size = "${var.volume_size}"
  }

  security_groups = ["${var.security_groups}"]

  associate_public_ip_address = true

  key_name = "${var.key_name}"

  connection {
    user        = "ubuntu"
    private_key = "${var.private_key}"
  }

  provisioner "ansible" {
    plays {
      playbook = "${path.module}/provision/playbook.yaml"

      # https://docs.ansible.com/ansible/2.4/intro_inventory.html#hosts-and-groups
      hosts = ["${self.public_hostname}"]
      groups = ["db-mongodb"]
    }
  }
}
