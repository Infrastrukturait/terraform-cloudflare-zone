module "zone" {
  source = "../.."

  zone = var.zone

  records = [
    {
      name  = "bastion-example"
      value = "1.1.1.1"
      type  = "A"
      ttl   = 1
    },
    {
      name  = "api-example"
      value = "1.1.1.1"
      type  = "A"
      ttl   = 1
    }
  ]
}
