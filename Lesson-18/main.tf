# credit D.Astahov
# edited by P.Sevko
# Terraform Loops: count and for if
#--------------------------------------------


provider "aws" {
    region = "eu-north-1"
}

variable "aws_users" {
    default     = ["vasya", "george", "kolya", "sveta", "misha", "bob", "Hector"]
    description = "List of IAM users to create"
}


resource "aws_iam_user" "user1" {
    name = "terminator"
}


resource "aws_iam_user" "users" {
    count   = length(var.aws_users)
    name    = element(var.aws_users, count.index)
}

/*
output "created_iam_users_all" {
    value = aws_iam_user.users
}
*/

output "created_iam_users_ids" {
    value = aws_iam_user.users[*].id
}

output "created_iam_users_custom" {
    value = [
        for i in aws_iam_user.users:
        "Hello Poweruser: ${i.name} has ARN: ${i.arn}"
    ]
}

output "created_iam_users_map" {
    value = {
        for g in aws_iam_user.users:
        g.unique_id => g.id //
    }
}

// print in outputs list of users with EXACT 5 characters name
output "custom_if_length" {
    value = [
        for x in aws_iam_user.users:
        x.name
        if length(x.name) == 5
    ]
}

resource "aws_instance" "servers" {
    count = 3
    ami = "ami-07dc21c599e19c4b7"
    instance_type = "t4g.small"
    tags = {
        Name = "Server Number - ${count.index + 1}"
    }
}

// print in outputs map of servers with server ID and public IP address
output "server_all" {
    value = {
        for server in aws_instance.servers:
        server.id => server.public_ip
    }
}