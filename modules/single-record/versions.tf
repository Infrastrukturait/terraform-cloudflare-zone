terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = ">= 3.23, < 5.0.0"
    }
  }

  required_version = ">= 0.14"
}
