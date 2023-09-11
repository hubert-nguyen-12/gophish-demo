# Configure Twingate Provider
  provider "twingate" {
    api_token = var.tg_api_key
    network   = var.tg_network
  }

  resource "aws_key_pair" "ssh_access_key" {
  key_name   = "vast_key_pair"
  public_key = file("${path.module}/../.ssh/id_rsa.pub")
  }

  resource "twingate_remote_network" "vast_demo_network" {
  name = "vast demo network"
  }

  resource "twingate_connector" "vast_demo_connector" {
  remote_network_id = twingate_remote_network.vast_demo_network.id
  }

  resource "twingate_connector_tokens" "vast_connector_tokens" {
  connector_id = twingate_connector.vast_demo_connector.id
  }

  data "aws_ami" "twingate" {
    most_recent = true

    filter {
      name   = "name"
      values = ["twingate/images/hvm-ssd/twingate-amd64-*"]
    }

    owners = ["617935088040"] # Twingate
  }

  resource "aws_instance" "twingate_connector" {
    ami           = data.aws_ami.twingate.id
    instance_type = "t3.micro"
    associate_public_ip_address = true
    key_name = aws_key_pair.ssh_access_key.key_name

  user_data = <<-EOT
    #!/bin/bash
    set -e
    mkdir -p /etc/twingate/
    {
      echo TWINGATE_URL="https://${var.tg_network}.twingate.com"
      echo TWINGATE_ACCESS_TOKEN="${twingate_connector_tokens.vast_connector_tokens.access_token}"
      echo TWINGATE_REFRESH_TOKEN="${twingate_connector_tokens.vast_connector_tokens.refresh_token}"
    } > /etc/twingate/connector.conf
    sudo systemctl enable --now twingate-connector
  EOT

  subnet_id              = aws_subnet.main.id

  tags = {
    "Name" = "Twingate Connector"
    }
  }

  resource "twingate_group" "aws_demo" {
    name = "aws demo group"
  }

