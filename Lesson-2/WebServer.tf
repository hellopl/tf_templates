#test WebServer
provider "aws" {
    region = "eu-north-1"
}


resource "aws_instance" "my_test_webserver" {
    ami                     = "ami-07dc21c599e19c4b7"
    instance_type           = "t4g.small"
    vpc_security_group_ids  = [aws_security_group.my_test_weserver.id]
    user_data = <<EOF
#!/bin/bash
yum -y update
yum -y install httpd
myip=`curl http://169.254.169.254/latest/meta-data/local-ipv4`
echo "<h2>WebServer with IP: $myip</h2><br><body bgcolor=pink><center><h2><p><font color=black>Build by Terraform!!!" > /var/www/html/index.html
sudo systemctl start httpd.service
sudo systemctl enable httpd.service
EOF

tags = {
    name = "WebServer Build by Terraform"
    Owner ="PavelS"
}
}


resource "aws_security_group" "my_test_weserver" {
  name      = "WebServer Security Group"
  description = "mytestwebserver security group"

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  ingress {
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
  tags = {
    name = "WebServer Security Group"
    Owner ="PavelS"
}

}
