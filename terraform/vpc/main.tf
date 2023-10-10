resource "aws_vpc" "deployment" {
  cidr_block           = "10.10.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "deployment"
  }
}

# Create an internet gateway

resource "aws_internet_gateway" "deploymentIGW" {
  vpc_id = aws_vpc.deployment.id

  tags = {
    Name = "deploymentIGW"
  }
}
/*
resource "aws_internet_gateway_attachment" "deployment" {
  internet_gateway_id = aws_internet_gateway.deploymentIGW.id
  vpc_id              = aws_vpc.deployment.id

}
*/

resource "aws_subnet" "deployment-public-subnet" {
  vpc_id     = aws_vpc.deployment.id
  cidr_block = "10.10.1.0/24"
  tags = {
    Name = "deployment-public-subnet"
  }
}


resource "aws_subnet" "deployment-private-subnet" {
  vpc_id     = aws_vpc.deployment.id
  cidr_block = "10.10.2.0/24"
  tags = {
    Name = "deployment-private-subnet"
  }
}

resource "aws_route_table" "deployment-publicRT" {
  vpc_id = aws_vpc.deployment.id

  route {

    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.deploymentIGW.id
  }

  route {

    cidr_block = aws_vpc.deployment.cidr_block
    gateway_id = "local"
  }

  tags = {
    Name = "publicRouteTable"
  }
}

resource "aws_route_table_association" "publicAssoc" {
  route_table_id = aws_route_table.deployment-publicRT.id
  subnet_id      = aws_subnet.deployment-public-subnet.id


}


resource "aws_route_table" "deployment-privateRT" {
  vpc_id = aws_vpc.deployment.id


  route {

    cidr_block = aws_vpc.deployment.cidr_block
    gateway_id = "local"


  }

  tags = {
    Name = "privateRouteTable"
  }
}


resource "aws_security_group" "deploymentSG" {
  name        = "deploymentSG"
  description = "Deployment Security Group"
  vpc_id      = aws_vpc.deployment.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_key_pair" "dev0" {
  key_name   = "aws0dev0"
  public_key = file("~/.ssh/aws0dev0.pub")
}

resource "aws_instance" "veritas" {

  instance_type               = "t3.micro"
  subnet_id                   = aws_subnet.deployment-public-subnet.id
  ami                         = data.aws_ami.server_ami.id
  key_name                    = aws_key_pair.dev0.id
  vpc_security_group_ids      = [aws_security_group.deploymentSG.id]
  associate_public_ip_address = true
  user_data                   = file("userdata.tpl")

  root_block_device {
    volume_size = 20
  }

  tags = {
    Name = "Veritas"
  }

}
