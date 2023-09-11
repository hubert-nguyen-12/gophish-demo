provider "mailgun" {
  api_key = "${var.mailgun_api_key}"
}

resource "mailgun_domain" "mailgun_phish" {
  name          = var.tl_domain
  region        = "us"
  spam_action   = "disabled"
  smtp_password   = var.mailgun_smtp_password
  dkim_key_size   = 1024
}