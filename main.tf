data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
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

resource "aws_instance" "mongodb" {
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

  key_name = "${var.key_name}"
  associate_public_ip_address = true
  security_groups = ["${var.security_groups}"]

  connection {
    user        = "ubuntu"
    private_key = "${var.private_key}"
  }

  provisioner "file" {
    source      = "${path.module}/provision/wait-for-cloud-init.sh"
    destination = "/tmp/wait-for-cloud-init.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/wait-for-cloud-init.sh",
      "/tmp/wait-for-cloud-init.sh",
    ]
  }

  provisioner "ansible" {
    plays {
      playbook = "${path.module}/provision/playbook.yaml"

      # https://docs.ansible.com/ansible/2.4/intro_inventory.html#hosts-and-groups
      groups = ["db-mongodb"]
    }
  }
}
