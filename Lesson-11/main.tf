#----------------------------------------------------------
# Provision Highly Availabe Web in any Region Default VPC
# Create:
#    - Security Group for Web Server
#    - Launch Configuration with Auto AMI Lookup
#    - Auto Scaling Group using 2 Availability Zones
#    - Classic Load Balancer in 2 Availability Zones
# Credit Denis Astahov
# Edited by Pavel Sevko 18-February-2023
#-----------------------------------------------------------

provider "aws" {
    region = "eu-north-1"
}

resource "aws_default_vpc" "default" {}

data "aws_availability_zones" "available" {}
data "aws_ami" "latest_amazon_linux2" {
    owners      = ["amazon"]
    most_recent = true
    filter {
        name        = "name"
        values      = ["amazon/amzn2-ami-kernel-5.10-hvm-*-arm64-gp2"]
    }
}

#-----------------------------------------------------------

resource "aws_security_group" "web" {
    name      = "Dynamic Security Group"
    vpc_id = aws_default_vpc.default.id


    dynamic "ingress" {
        for_each = ["80", "443"]
        content {
            from_port       = ingress.value
            to_port         = ingress.value
            protocol        = "tcp"
            cidr_blocks     = ["0.0.0.0/0"]
        }
    }

    egress {
        from_port       = 0
        to_port         = 0
        protocol        = "-1"
        cidr_blocks     = ["0.0.0.0/0"]
    }

    tags = {
        name = "Dynamic Security Group"
        Owner ="Pavel Sevko"
    }
}

#-----------------------------------------------------------

resource "aws_launch_configuration" "web" {
    // name                = "WebServer-Highly-Available"
    name_prefix         = "WebServer-Highly-Available-LC"
    image_id            = data.aws_ami.latest_amazon_linux2.id
    instance_type       = "t4g.small"
    security_groups     = [aws_security_group.web.id]
    user_data           = file("user_data.sh")

    lifecycle {
        create_before_destroy = true
    }
}


resource "aws_autoscaling_group "web" {
    name                        = "ASG-${aws_launch_configuration.web.name}"
    launch_configuration        = aws_launch_configuration.web.name
    min_size                    = 2 
    max_size                    = 2
    min_elb_capacity            = 2
    health_check_type           = "ELB"
    vpc_zone_identifier         = [aws_default_subnet.default_az1.id, aws_default_subnet.default_az2.id]
    load_balancers              = [aws_elb.web.name]

    dynamic "tag" {
        for_each = {
            Name    = "WebServer in ASG"
            Owner   = "Pavel Sevko"
            TAGKEY  = "TAGVALUE"
        }
        content {
            key                 = tag.key
            value               = tag.value
            propagate_at_launch = true
        }
    }

    lifecycle {
        create_before_destroy = true
    }
}


resource "aws_elb "web" {
    name                = "WebServer-HA-ELB"
    availability_zones  = [data.aws_availability_zones.available.names[0], data.aws_availability_zones.available.names[1]]
    security_groups     = [aws_security_group.web.id]
    listener {
        lb_port             = 80
        lb_protocol         = "http"
        instance_port       = 80
        instance_protocol   = "http"
    }
    health_check {
        healthy_treshold    = 2
        unhealthy_treshold  = 2
        timeout             = 3
        target              = "HTTP:80/"
        interval            = 10
    }
    tags    = {
        Name = "WebServer-Highly-Available-ELB"
    }
}


resource "aws_default_subnet" "default_az1" {
    availability_zone = data.aws_availability_zones.available.names[0]
}

resource "aws_default_subnet" "default_az2" {
    availability_zone = data.aws_availability_zones.available.names[1]
}

#-------------------------------------------------------------------------------------------

output "web_loadbalancer_url" {
    value = aws_elb.web.dns_name
}
