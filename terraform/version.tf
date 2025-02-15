terraform {
  required_providers {
    ansible = {
      #   version = "~> 1.1.0"
      #   source  = "ansible/ansible"
      source  = "jdziat/ansible"
      version = "1.2.1"
    }


    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}