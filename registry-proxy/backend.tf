terraform {
  backend "gcs" {
    bucket  = "cloudsphere-production-tfstate"
    prefix  = "registry-proxy-tfstate"
  }
}