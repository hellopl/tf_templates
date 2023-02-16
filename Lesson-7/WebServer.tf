#test WebServer
provider "aws" {
    region = "eu-north-1"
}

resource "aws_default_vpc" "default" {}

resource "aws_eip" "my_static_ip" {
  instance = aws_instance.my_test_webserver.id
  vpc      = true
  tags = {
      name = "WebServer Elastic IP"
      Owner ="PavelS"
  }
}

resource "aws_instance" "my_test_webserver" {
    ami                     = "ami-07dc21c599e19c4b7"
    instance_type           = "t4g.small"
    vpc_security_group_ids  = [aws_security_group.my_test_webserver.id]
    user_data = templatefile("user_data.sh.tpl", {
      f_name = "Pavel",
      l_name = "Sevko",
      names  = ["Bob", "Igor", "Monica", "John", "Maya", "Test", "Ninja", "T1000"]
    })
    user_data_replace_on_change = true

    tags = {
      name = "WebServer Build by Terraform"
      Owner ="PavelS"
    }

    lifecycle {
      create_before_destroy = true
    }
}


resource "aws_security_group" "my_test_webserver" {
  name      = "WebServer Security Group"
  description = "mytestwebserver security group"
  vpc_id      = aws_default_vpc.default.id

  dynamic "ingress" {
    for_each = ["80", "443"]
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    name = "WebServer Security Group"
    Owner ="PavelS"
}
}