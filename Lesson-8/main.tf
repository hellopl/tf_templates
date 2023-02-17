#test WebServer
provider "aws" {
    region = "eu-north-1"
}

resource "aws_instance" "my_server_web" {
    ami                     = "ami-07dc21c599e19c4b7"
    instance_type           = "t4g.small"
    vpc_security_group_ids  = [aws_security_group.my_webserver.id]
  
      tags = {
      Name = "Server-Web"
    }
    depends_on = [aws_instance.my_server_db, aws_instance.my_server_app]
}

resource "aws_instance" "my_server_app" {
    ami                     = "ami-07dc21c599e19c4b7"
    instance_type           = "t4g.small"
    vpc_security_group_ids  = [aws_security_group.my_webserver.id]
  
      tags = {
      Name = "Server-App"
    }
    depends_on = [aws_instance.my_server_db]
}

resource "aws_instance" "my_server_db" {
    ami                     = "ami-07dc21c599e19c4b7"
    instance_type           = "t4g.small"
    vpc_security_group_ids  = [aws_security_group.my_webserver.id]
  
      tags = {
      Name = "Server-DB"
    }
}


resource "aws_security_group" "my_webserver" {
  name      = "My Security Group"

  dynamic "ingress" {
    for_each = ["80", "443", "22"]
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
    name = "My SecurityGroup"
    Owner ="PavelS"
}
}