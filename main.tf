provider "google" {
  project = var.project_id
  region  = var.region
}

terraform {
  backend "gcs" {
    bucket = "YOUR_BUCKET_NAME"
    prefix = "terraform/state"
  }
}

module "network" {
  source  = "terraform-google-modules/network/google"
  version = "~> 2.0"
  project_id   = var.project_id
  network_name = "vpc-network"
  subnets = [
    {
      subnet_name           = "subnet-1"
      subnet_ip             = "10.0.0.0/24"
      subnet_region         = var.region
      subnet_private_access = true
    }
  ]
}
