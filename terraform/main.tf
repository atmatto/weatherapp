terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

resource "tls_private_key" "ssh_key" {
  algorithm = "ED25519"
}

resource "local_file" "ssh_key" {
  content         = tls_private_key.ssh_key.private_key_openssh
  filename        = "../id_ed25519"
  file_permission = "0600"
}

provider "aws" {
  region     = "eu-central-1"
  access_key = chomp(file("aws_access_key"))
  secret_key = chomp(file("aws_secret_key"))
}

resource "aws_default_vpc" "default" {}

resource "aws_security_group" "main" {
  vpc_id = aws_default_vpc.default.id
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_instance" "weatherapp_server" {
  ami           = "ami-0bb845605288e396a"
  instance_type = "t2.micro"
  user_data     = templatefile("cloud-init.yaml", { public_key = tls_private_key.ssh_key.public_key_openssh })
  vpc_security_group_ids = [aws_security_group.main.id]

  tags = {
    Name = "WeatherAppServerInstance"
  }
}

