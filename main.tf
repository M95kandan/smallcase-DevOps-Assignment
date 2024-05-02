
provider "aws" {
  region = "ap-south-1"
}

data "aws_ami" "ubuntu_latest" {
  most_recent = true
  owners = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}

resource "aws_instance" "smallcase-ass-ec2" {
  ami                         = data.aws_ami.ubuntu_latest.id
  instance_type               = "t2.micro"
  subnet_id                   = "subnet-00becfc5e28a8e977" # Update with a subnet in your VPC
  associate_public_ip_address = true
  key_name                    = "smallcase-ass.pem" # Update with your key name
  security_groups             = ["${aws_security_group.instance_sg.name}"]

  tags = {
    Name = "Backend Instance"
  }

  root_block_device {
    encrypted   = true
    kms_key_id  = aws_kms_key.kms.arn
  }

  ebs_block_device {
    device_name = "/dev/sdb"
    encrypted   = true
    kms_key_id  = aws_kms_key.kms.arn
    volume_size = 10
  }
}

resource "aws_security_group" "instance_sg" {
  name        = "instance_sg"
  description = "Security group for EC2 instance"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Open SSH from anywhere
  }

  ingress {
    from_port   = 8081
    to_port     = 8081
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Open port 8081 from anywhere
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "null_resource" "ansible_inventory" {
  triggers = {
    ansibleWebPlaybook = timestamp()
  }

  provisioner "local-exec" {
    command = <<-EOT
      echo "[smallcase-docker]" > inventory
      echo "${join("\\n", aws_instance.smallcase-ass-ec2[*].public_ip)}" >> inventory
    EOT
  }
}

resource "null_resource" "ansible_playbook_execution" {
  provisioner "local-exec" {
    command = "ansible-playbook -i inventory docker-build.yml"
  }

  provisioner "local-exec" {
    command = "ansible-playbook -i inventory docker-launch.yml"
  }
}

resource "aws_kms_key" "kms" {
  description = "KMS key for EBS volume encryption"
}
