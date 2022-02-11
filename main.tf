variable "env" {}

module "dev_server" {
  source        = "./http_server"
  instance_type = "t3.micro"
}

provider "aws" {
  region = "ap-northeast-1"
}

locals {
  example_instance_type = "t3.micro"
}

resource "aws_security_group" "example_ec2" {
  name = "example-ec2"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

data "template_file" "httpd_user_data" {
  template = file("./user_data.sh.tpl")

  vars = {
    package = "httpd"
  }
}

resource "aws_instance" "example" {
  ami                    = "ami-0f9ae750e8274075b"
  instance_type          = var.env == "prod" ? "m5.large" : local.example_instance_type
  vpc_security_group_ids = [aws_security_group.example_ec2.id]
  user_data              = data.template_file.httpd_user_data.rendered

  tags = {
    Name = "example"
  }
}

output "example_public_dns" {
  value = aws_instance.example.public_dns
}

output "public_dns" {
  value = module.dev_server.public_dns
}