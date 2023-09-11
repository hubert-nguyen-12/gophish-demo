
variable "tl_domain" { default = "evilvastspace.com" }
variable "gophish_ssh_key" { 
    type = string
    default = "../.ssh/gophish_id_rsa.pub" 
    }
variable "tg_api_key" {}
variable "tg_network" {}
variable "record_ttl" { default = "300"}
variable "mailgun_api_key" { default = "" }
variable "mailgun_smtp_password" { default = "" }
variable "mailgun_domain" { default = "" }