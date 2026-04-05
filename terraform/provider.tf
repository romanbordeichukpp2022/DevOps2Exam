variable "do_token" {}
variable "spaces_access_id" {}
variable "spaces_secret_key" {}

provider "digitalocean" {
  token = var.do_token
  
  spaces_access_id  = var.spaces_access_id
  spaces_secret_key = var.spaces_secret_key
}

terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }

  backend "s3" {
    endpoint                    = "https://fra1.digitaloceanspaces.com" 
    region                      = "us-east-1" # Залишаємо заглушку для S3 API
    bucket                      = "bordeichuk-terraform-state" 
    key                         = "terraform.tfstate"
    
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    skip_region_validation      = true
    skip_requesting_account_id  = true
    
    use_path_style              = true 
  }
}