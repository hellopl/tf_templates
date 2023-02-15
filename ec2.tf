provider "aws" { #add EC2 instance in Stockholm region
    region = "eu-north-1"
}

resource "aws_instance" "my_amilinux" {
    count           = 2
    ami             = "ami-07dc21c599e19c4b7"
    instance_type   = "t4g.small"

    tags = {
        Name    = "My amilinuxes"
        Owner   = "PavelS"
        Project = "test templates"
    }
}
