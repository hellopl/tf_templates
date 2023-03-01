# credit D.Astahov
# edit by P.Sevko
# Conditions and Lookups
#------------------------------------------


provider "aws" {
    region = "eu-north-1"
}


variable "env" {
    default = "dev"
}

variable "prod_owner" {
    default = "Pavel Sevko"
}

variable "noprod_owner" {
    default = "Mister Bob"
}

variable "ec2_size" {
    default = {
        "prod"      ="t4g.medium"
        "dev"       ="t4g.small"
        "test"      ="t4g.micro"
    }
}

variable "allow_port_list" {
    default = {
        "prod"  = ["80", "443"]
        "dev"   = ["80", "443", "8080", "22"]
        "test"  = ["80", "443", "8080", "22", "1541", "9092"]
    }
}

resource "aws_instance" "my_web_server1" {
    ami = "ami-07dc21c599e19c4b7"
#    instance_type = var.env == "prod" ? "t4g.large" : "t4g.small"
    instance_type = var.env == "prod" ? var.ec2_size["prod"] : var.ec2_size["test"]    
    tags = {
        Name    = "${var.env} - server"
        Owner   = var.env == "prod" ? var.prod_owner : var.noprod_owner
    }
}


resource "aws_instance" "my_web_server2" {
    ami = "ami-07dc21c599e19c4b7"
    instance_type = lookup(var.ec2_size, var.env)
    
    tags = {
        Name    = "${var.env} - server"
        Owner   = var.env == "prod" ? var.prod_owner : var.noprod_owner
    }
}

resource "aws_instance" "my_dev_bastion" {
    count           = var.env == "dev" ? 1 : 0
    ami             = "ami-07dc21c599e19c4b7"
    instance_type   = "t4g.micro"
    
    tags = {
        Name = "Bastion Server for Dev-server"
    }
}


resource "aws_security_group" "my_test_webserver" {
    name      = "Dynamic Security Group"


 # This dynamic block creates ingress rules for each port specified in the list
    dynamic "ingress" {
        for_each = lookup(var.allow_port_list, var.env)
        content {
            from_port       = ingress.value
            to_port         = ingress.value
            protocol        = "tcp"
            cidr_blocks     = ["0.0.0.0/0"]
        }
    }

    # This block creates an egress rule that allows all traffic to all destinations
    egress {
        from_port       = 0
        to_port         = 0
        protocol        = "-1"
        cidr_blocks     = ["0.0.0.0/0"]
    }

    # These tags help identify the resource
    tags = {
        name = "Dynamic Security Group"
        Owner ="PavelS"
    }
}