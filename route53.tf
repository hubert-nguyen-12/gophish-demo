resource "aws_route53_zone" "primary" {
  name = var.tl_domain
}

resource "aws_route53_record" "primary" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = var.tl_domain
  type    = "A"
  ttl     = "300"
  records = ["${aws_instance.gophish.public_ip}"]
}

resource "aws_route53_record" "spf" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = var.tl_domain
  type    = "TXT"
  ttl     = "300"
  records = ["v=spf1 include:mailgun.org ~all"]
}

resource "aws_route53_record" "dkim" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "pic._domainkey.${var.tl_domain}"
  type    = "TXT"
  ttl     = "300"
  records = ["k=rsa; p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDJeh5e0KtI8tR4sFkE1X0x6T+CP1vwesJsObfLCHDGGG18aD9+NQmKIcDSGU4iIf/IY2DQ58AMKwS6ba41aC1NgTVOb/30jeDyOn4ibxZB+PljVjsPX6WPFwqLnI2k8BjWvVr9NGU726vcEXvHrJxtrvmTtP83b55fLe0JODbVZQIDAQAB"]
 }

resource "aws_route53_record" "mx" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = var.tl_domain
  type    = "MX"
  ttl     = "300"
  records = ["10 mxa.mailgun.org", "10 mxb.mailgun.org"]
}

resource "aws_route53_record" "cname" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "email.${var.tl_domain}"
  type    = "CNAME"
  ttl     = "300"
  records = ["mailgun.org"]
}