terraform {
  backend "gcs" {
    bucket  = "test-production-tfstate"
    prefix  = "registry-proxy-tfstate"
  }
}