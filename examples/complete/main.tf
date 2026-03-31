module "zone" {
  source = "../.."

  zone       = var.zone
  account_id = var.account_id

  records = [
    {
      record_name = "bastion-example-a"
      name        = "bastion-example"
      value       = "1.1.1.1"
      type        = "A"
      ttl         = 1
    },
    {
      record_name = "api-example-a"
      name        = "api-example"
      value       = "1.1.1.1"
      type        = "A"
      ttl         = 1
    }
  ]
}
