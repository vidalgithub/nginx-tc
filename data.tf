data "aws_acm_certificate" "example_certificate" {
  domain       = var.dns 
  most_recent  = true
}