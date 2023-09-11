data "aws_ami" "ubuntu" {
    most_recent = true

    filter {
        name   = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
    }

    filter {
        name   = "virtualization-type"
        values = ["hvm"]
    }

    owners = ["099720109477"] # Canonical
}

resource "aws_key_pair" "gophish_ssh_access_key" {
  key_name   = "gophish_key_pair"
  public_key = file("${path.module}/../.ssh/gophish_id_rsa.pub")
  }

resource "aws_instance" "gophish" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"
  associate_public_ip_address = true
  key_name      = aws_key_pair.gophish_ssh_access_key.key_name
  subnet_id     = aws_subnet.main.id

  user_data = <<-EOT
    #!/bin/bash
    sudo apt install unzip
    sudo mkdir /opt/gophish
    sudo cd /opt/gophish
    sudo wget -O gophish.zip 'https://github.com/gophish/gophish/releases/download/v0.12.1/gophish-v0.12.1-linux-64bit.zip'
    sudo unzip gophish.zip
    sudo rm gophish.zip
    sudo sed -i 's|127\.0\.0\.1|0\.0\.0\.0|g' config.json
    sudo chmod +x ./gophish
    sudo ./gophish > gophish.log 2>&1
    EOT
  tags = {
    "Name" = "Gophish Server"
  }
  
  }