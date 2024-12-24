terraform { # Include Terraform setting that required providers that terraform will use to provision the infrastructure
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" { 
  region  = "ap-southeast-1"
}

resource "aws_vpc" "example_vpc" {
    cidr_block = "10.0.0.0/16"
    tags = {
        Name = "ExampleVPC"
    }
}

resource "aws_subnet" "example_subnet" {
    vpc_id = aws_vpc.example_vpc.id
    cidr_block = "10.0.1.0/24"
    availability_zone = "ap-southeast-1a"
    tags = {
      Name = "ExampleSubnet"
    }
}

resource "aws_internet_gateway" "example_igw" {
    vpc_id = aws_vpc.example_vpc.id
    tags = {
      Name = "ExampleIGW"
    }
}

resource "aws_route_table" "example_route_table" {
  vpc_id = aws_vpc.example_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.example_igw.id
  }

  tags = {
    Name = "ExampleRouteTable"
  }
}

resource "aws_route_table_association" "example_route_table_association" {
  subnet_id      = aws_subnet.example_subnet.id
  route_table_id = aws_route_table.example_route_table.id
}


resource "aws_instance" "app_server" { 
  ami           = "ami-06650ca7ed78ff6fa"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.example_subnet.id

  tags = {
    Name = "ExampleAppServerInstance"
  }
}
