resource "aws_vpc" "deployment" {
  cidr_block = "10.10.0.0/16"

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


/*

# Create NAT Gateway
resource "aws_nat_gateway" "deploymentNAT" {
  allocation_id = aws_eip.deployemntEIP.id
  subnet_id     = aws_subnet.deployment-public-subnet

  tags = {

    "Name" = "deploymentNAT"
  }

}
*/


resource "aws_security_group" "deploymentSG" {
  name        = "deploymentSG"
  description = "Deployment Security Group"
  vpc_id      = aws_vpc.deployment.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["102.216.154.100/31"]
  }
}


resource "aws_instance" "veritas" {
  ami           = "ami-00b7cc7d7a9f548ea"
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.deployment-public-subnet.id

  tags = {
    Name = "Veritas"
  }
}
