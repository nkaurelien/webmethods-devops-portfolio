provider "aws" {
  region = "us-west-2"
}

# Creating key-pair on AWS using SSH-public key
resource "aws_key_pair" "deployer" {
  key_name   = var.key-name
  public_key = file("${path.module}/${var.ssh_public_key}")
}


resource "aws_instance" "sag_cc_spm_server" {
  # count         = 2
  ami           = data.aws_ami.ubuntu22canonical.id
  instance_type = "t2.medium"

  security_groups = [aws_security_group.sag_cc_spm_sg.name]

  key_name = aws_key_pair.deployer.key_name

  tags = {
    Name        = var.instance_slug
    Creator     = "nkaurelien@gmail.com"
    Environment = "sandbox"
    Compagny    = "wilow"
  }


  user_data = <<EOF
#!/bin/bash
sudo apt-get update
sudo apt-get install -y htop s3fs curl
sudo apt-get install -y nginx
sudo systemctl start nginx
sudo systemctl enable nginx
EOF
}

