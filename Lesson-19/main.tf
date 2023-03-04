# credit D.Astahov
# edited by P.Sevko
# Terraform - resources in multiple AWS Regions/accounts 
#--------------------------------------------


provider "aws" {
    region = "eu-north-1"

/*
    assume_role {
        role_arn = "arn:aws:iam::12333312312:role/RemoteAdministrators"
        session_name = "skynet_session"
    }
}
*/


provider "aws" {
    region = "eu-west-1"
    alias = "EU"
}

provider "aws" {
    region = "us-east-1"
    alias = "USA"
}

#---------------------------------------------------------------------------

data "aws_ami" "default_latest_amilinux" {
    owners      = ["amazon"]
    most_recent = true
    filter {
        name        = "name"
        values      = ["amzn2-ami-hvm-*-x86_64-gp2"]
    }
}


data "aws_ami" "usa_latest_amilinux" {
    provider = aws.USA
    owners      = ["amazon"]
    most_recent = true
    filter {
        name        = "name"
        values      = ["amzn2-ami-hvm-*-x86_64-gp2"]
    }
}

data "aws_ami" "eu_latest_amilinux" {
    provider = aws.EU
    owners      = ["amazon"]
    most_recent = true
    filter {
        name        = "name"
        values      = ["amzn2-ami-hvm-*-x86_64-gp2"]
    }
}

#-----------------------------------------------------------------------------

resource "aws_instance" "my_default_server" {
    ami             = data.aws_ami.default_latest_amilinux.id
    instance_type   = "t3.micro"
    tags = {
        Name = "Default Server"
    }
}

output "default_ami_image_id" {
    value = data.aws_ami.default_latest_amilinux.id
}
 

resource "aws_instance" "my_USA_server" {
    provider = aws.USA
    ami             = data.aws_ami.usa_latest_amilinux.id
    instance_type   = "t3.micro"
    tags = {
        Name = "USA Server"
    }
}

output "usa_ami_image_id" {
    value = data.aws_ami.usa_latest_amilinux.id
}
 

resource "aws_instance" "my_EU_server" {
    provider = aws.EU
    ami             = data.aws_ami.eu_latest_amilinux.id
    instance_type   = "t3.micro"
    tags = {
        Name = "EU Server"
    }
}

output "eu_ami_image_id" {
    value = data.aws_ami.eu_latest_amilinux.id
}