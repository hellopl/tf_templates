provider "aws" {
    region = "eu-north-1"
}

resource "null_resource" "command1" {
    provisioner "local-exec" {
        command = "echo Terraform START: $(date) >> log.txt"
    }
}

/*
resource "null_resource" "command2" {
    provisioner "local-exec" {
        command     = "ping -c 5 www.google.com"
    }
#   depends_on     = [null_resource.command1]
}
*/

resource "null_resource" "command3" {
    provisioner "local-exec" {
#       command    = "python -c 'print ('Hello world')"
        command     = "print('Hello World!')"
        interpreter = ["python3", "-c"]
    }
}

resource "null_resource" "command4" {
    provisioner "local-exec" {
        command         = "echo $NAME1 $NAME2 $NAME3 >> names.txt"
        environment     = {
            NAME1       = "BOB"
            NAME2       = "Monica"
            NAME3       = "Gerorge"
        }
    }
}

 