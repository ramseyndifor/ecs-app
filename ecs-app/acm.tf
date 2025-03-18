# Request a wildcard SSL certificate for the imported domain
resource "aws_acm_certificate" "wildcard_cert" {
  domain_name       = "*.${data.aws_route53_zone.r53_hosted_zone.name}"  # Wildcard certificate
  validation_method = "EMAIL"

  validation_option {
    domain_name       = "ramseyndifor.com"
    validation_domain = "*.ramseyndifor.com"
  }

  lifecycle {
    create_before_destroy = true
  }
}

# # Add DNS validation records to the hosted zone
# resource "aws_route53_record" "cert_validation" {
#   for_each = {
#     for dvo in aws_acm_certificate.wildcard_cert.domain_validation_options : dvo.domain_name => {
#       name  = dvo.resource_record_name
#       type  = dvo.resource_record_type
#       value = dvo.resource_record_value
#     }
#   }

#   zone_id = data.aws_route53_zone.r53_hosted_zone.zone_id
#   name    = each.value.name
#   type    = each.value.type
#   records = [each.value.value]
#   ttl     = 60
# }

# # Validate the certificate
# resource "aws_acm_certificate_validation" "wildcard_cert_validation" {
#   certificate_arn         = aws_acm_certificate.wildcard_cert.arn
#   validation_record_fqdns = [for record in aws_route53_record.cert_validation : record.fqdn]
# }