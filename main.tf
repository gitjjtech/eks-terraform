terraform {
  required_version = "~> 1.2.1"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.20.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.11.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.5.1"
    }
  }

  backend "s3" {
    bucket  = "tania-tfstate-bucket"
    key     = "test-eks-tfstate"
    region  = "us-east-1"
    encrypt = true
  }


}
