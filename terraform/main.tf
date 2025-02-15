provider "aws" {
  region = "us-west-2"
}


resource "aws_instance" "sag_cc_spm_server" {
  # count         = 2
  ami           = data.aws_ami.ubuntu22canonical.id
  instance_type = "t2.medium"

  security_groups = [aws_security_group.sag_cc_spm_sg.name]

  tags = {
    Name        = var.instance_slug
    Creator     = "nkaurelien@gmail.com"
    Environment = "sandbox"
    Compagny    = "wilow"
  }


  user_data = <<EOF
#!/bin/bash
sudo apt-get update
sudo apt-get install -y htop
sudo apt-get install -y nginx
sudo systemctl start nginx
sudo systemctl enable nginx
EOF
}

