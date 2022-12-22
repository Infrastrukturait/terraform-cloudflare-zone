terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = ">= 3.23"
    }
  }

  required_version = ">= 0.14"
}
