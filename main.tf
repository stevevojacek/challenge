provider "aws" {
    region = "us-east-1"
}
#Main VPC
resource "aws_vpc" "challengevpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "VPC for Webservers"
  }
}

#Public Subnet
resource "aws_subnet" "public" {
    vpc_id = aws_vpc.challengevpc.id
    cidr_block = "10.0.1.0/24"
    availability_zone = "us-east-1a"
    tags = {
        Name = "Public Subnet"
    }
}

#Private Subnet
resource "aws_subnet" "private" {
    vpc_id = aws_vpc.challengevpc.id
    cidr_block = "10.0.2.0/24"
    availability_zone = "us-east-1a"
    tags = {
        Name = "Private Subnet"
    }
}

#Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.challengevpc.id
  tags = {
    Name = "Challenge IGW"
  }
}

#Elastic IP for NAT Gateway
resource "aws_eip" "nat_eip" {
    vpc = true
    depends_on = [aws_internet_gateway.igw]
    tags = {
        Name = "Nat Gateway eip" 
    }
}

#NAT Gateway for VPC
resource "aws_nat_gateway" "nat" {
    allocation_id = aws_eip.nat_eip.id
    subnet_id = aws_subnet.public.id
  
  tags = {
    Name = "NAT Gateway"
  }
}

#Route Table for Public Subnet
resource "aws_route_table" "public" {
    vpc_id = aws_vpc.challengevpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id
    }
        tags = {
            Name = "Public route table"
        }
    }
  
#Route table association
resource "aws_route_table_association" "public" {
    subnet_id = aws_subnet.public.id
    route_table_id = aws_route_table.public.id

  
}

#Security Group for Web
resource "aws_security_group" "websg" {
    name = "WebServer-Steve"
    description = "SG for the webserver"
    vpc_id = aws_vpc.challengevpc.id

    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }    
    
    tags = {
        Name = "SG for the webservers"
        Owner = "Steve" 
    }
    
}
#Primary Web Server Instance
#resource "aws_instance" "web" {
#    ami           = "ami-006dcf34c09e50022"
#    instance_type = "t2.micro"
#    subnet_id = aws_subnet.public.id
#    vpc_security_group_ids = [aws_security_group.websg.id]
#    associate_public_ip_address = true
#    user_data     = <<EOF
##!/bin/bash
#yum -y update
#yum -y install httpd
#echo "<h2>Hello World - Webserver 1</h2><br>" > /var/www/html/index.html
#service httpd start
#chkconfig httpd on
#EOF
#    tags = {
#        Name = "Web Server 1"
#        Owner = "Steve"
#    }
#}

#Secondary Web Server Instance
#resource "aws_instance" "web2" {
#    ami           = "ami-006dcf34c09e50022"
#    instance_type = "t2.micro"
#    subnet_id = aws_subnet.public.id
#    vpc_security_group_ids = [aws_security_group.websg.id]
#    associate_public_ip_address = true
#    user_data     = <<EOF
##!/bin/bash
#yum -y update
#yum -y install httpd
#echo "<h2>Hello World - Webserver 2</h2><br>" > /var/www/html/index.html
#service httpd start
#chkconfig httpd on
#EOF
#    tags = {
#        Name = "Web Server 2"
#        Owner = "Steve"
#   }
#}