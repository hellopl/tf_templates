variable "region" {
    description = "Please enter a AWS region to deploy server"
    type = string
    default = "eu-north-1"
}

variable "instance_type" {
    description = "Enter instance type"
    type = string
    default = "t4g.small"
}

variable "allow_ports" {
    description = "List of default open ports on Server"
    type = list
    default = ["80", "443", "22", "8080"]


}