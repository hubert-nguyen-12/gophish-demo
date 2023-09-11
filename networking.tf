  resource "aws_vpc" "main" {
    cidr_block = "172.10.0.0/16"
    enable_dns_support = true
    enable_dns_hostnames = true
  }

  resource "aws_subnet" "main" {
    vpc_id     = aws_vpc.main.id
    cidr_block = "172.10.0.0/24"
  }

  resource "aws_internet_gateway" "gw" {
    vpc_id = aws_vpc.main.id

  tags = {
    Name = "my-gateway"
    }
  }

resource "aws_route_table" "example" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0" #allow all
    gateway_id = aws_internet_gateway.gw.id
  }

  route {
    ipv6_cidr_block = "::/0"
    gateway_id      = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "my-route-table"
  }
}

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.main.id
  route_table_id = aws_route_table.example.id
}

resource "aws_default_security_group" "default" {
  vpc_id = aws_vpc.main.id

   ingress = [
    {
      description = "Allow SSH"
      from_port = 22 
      to_port = 22
      protocol = "tcp"
      cidr_blocks = [ "0.0.0.0/0" ]
      ipv6_cidr_blocks = []
      self = false
      prefix_list_ids = []
      security_groups = []
    },
    {
      description = "Allow HTTP"
      from_port = 80 
      to_port = 80
      protocol = "tcp"
      cidr_blocks = [ "0.0.0.0/0" ]
      ipv6_cidr_blocks = []
      self = false
      prefix_list_ids = []
      security_groups = []
    },
    {
      description = "Allow access to Gophish server"
      from_port = 3333
      to_port = 3333
      protocol = "tcp"
      cidr_blocks = [ "0.0.0.0/0" ]
      ipv6_cidr_blocks = []
      self = false
      prefix_list_ids = []
      security_groups = []
    }
  ]

  egress = [
    {
      description = "Allow outbound traffic to anywhere"
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = [ "0.0.0.0/0" ]
      ipv6_cidr_blocks = []
      self = false
      prefix_list_ids = []
      security_groups = []
    }
  ]
}