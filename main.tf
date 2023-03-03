provider "aws" {
    region = "us-east-1"
}

resource "aws_instance" "web" {
    ami           = "ami-0dfcb1ef8550277af" //Amazon Linux
    instance_type = "t2.micro"
    vpc_security_group_ids = [aws_security_group.web.id]
    user_data     = <<EOF
#!/bin/bash
yum -y update
yum -y install httpd
MYIP=`curl http://169.254.169.254/latest/meta-data/local-ipv4`
echo "<h2>Webserver with PrivateIP: $MYIP</h2><br>Built by Terraform" > /var/www/html/index.html
service httpd start
chkconfig httpd on
EOF
    tags = {
        Name = "Steve Server"
        Owner = "Steve Oro"
    }
}
resource "aws_security_group" "web" {
    name = "WebServer-Steve"
    description = "Para mi servidor Web"

    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 443
        to_port = 443
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
        Name = "Steve Webserver SecGroup"
        Owner = "Steve Oro" 
    }
    
}