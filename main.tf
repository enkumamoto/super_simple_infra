terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.75.0"
    }
    docker = {
      source  = "kreuzwerker/docker"
      version = "3.0.2"
    }
    grafana = {
      source = "grafana/grafana"
      version = "3.13.1"
    }
  }
}

provider "aws" {
  region = "us-east-1"
  access_key = "access_key"
  secret_key = "secret_key"
}

provider "docker" {

}

provider "grafana" {
  
}