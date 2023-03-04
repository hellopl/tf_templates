provider "aws" {
    region = "eu-north-1"
}

terraform {
    backend "s3" {
        bucket = "pavelsevko-terraform-testproject"
        key    = "dev/servers/terraform.tfstate"
        region = "eu-north-1"
    }
}


data "terraform_remote_state" "network" {
    backend = "s3"
    config = {
        bucket = "pavelsevko-terraform-testproject"
        key    = "dev/network/terraform.tfstate"
        region = "eu-north-1"
    }
}


data "aws_ami" "latest_amilinux" {
    owners          = ["amazon"]
    most_recent     = true
    filter {
        name        = "name"
        values      = ["amzn2-ami-hvm-*-x86_64-gp2"]
    }
}

resource "aws_instance" "web_server" {
    ami                     = data.aws_ami.latest_amilinux.id
    instance_type           = "t3.micro"
    vpc_security_group_ids  = [aws_security_group.webserver.id]
    subnet_id               = data.terraform_remote_state.network.outputs.public_subnet_ids[0]
    user_data = <<EOF
#!/bin/bash
yum -y update
yum -y install httpd
myip=`curl http://169.254.169.254/latest/meta-data/local-ipv4`
echo "<h2>WebServer with IP: $myip</h2><br><body bgcolor=pink><center><h2><p><font color=black>Build by Terraform and remote state!!!" > /var/www/html/index.html
sudo systemctl start httpd.service
sudo systemctl enable httpd.service
EOF
    tags = {
        Name = "${var.env}-WebServer"
    }
}


resource "aws_security_group" "webserver" {
    name    = "WebServer Security Group"
    vpc_id  = data.terraform_remote_state.network.outputs.vpc_id

    ingress {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks =["0.0.0.0/0"]
    }

    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks =[data.terraform_remote_state.network.outputs.vpc_cidr]
    }    

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks =["0.0.0.0/0"]
    }

    tags = {
        Name    = "web-server-sg"
        Owner   = "Pavel Sevko"
    }
}

