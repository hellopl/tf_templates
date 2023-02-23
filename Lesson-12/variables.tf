variable "region" {
    description = "Please enter a AWS region to deploy server"
    type        = string
    default     = "eu-north-1"
}

variable "instance_type" {
    description = "Enter instance type"
    type        = string
    default     = "t4g.small"
}

variable "allow_ports" {
    description = "List of default open ports on Server"
    type        = list
    default     = ["80", "443", "22", "8080"]
}

variable "enable_detailed_monitoring" {
    type        = bool
    default     = false
}

variable "common_tags" {
    description = "Common Tags to apply to all resources"
    type = map
    default = {
        Owner           ="PavelS"
        Project         = "T1000"
        CostCenter      = "007"
        Environment     = "development"
    }
}