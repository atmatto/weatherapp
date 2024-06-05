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
  access_key = file("aws_access_key")
  secret_key = file("aws_secret_key")
}

resource "aws_instance" "weatherapp_server" {
  ami           = "ami-0e657cc9ee57cfba0" # TOOD: https://aws.amazon.com/marketplace/pp/prodview-a2hsmwr6uilqq
  instance_type = "t2.micro"
  user_data     = templatefile("cloud-init.yaml", { public_key = tls_private_key.ssh_key.public_key_openssh })

  tags = {
    Name = "WeatherAppServerInstance"
  }
}

