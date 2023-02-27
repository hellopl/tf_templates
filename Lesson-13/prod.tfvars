#autofill parameters for DEV

region                          = "eu-north-1"
instance_type                   = "t4g.medium"
enable_detailed_monitoring      = true

allow_ports                     = ["80", "443"]

common_tags = {
        Owner           ="PavelS"
        Project         = "T1000"
        CostCenter      = "007"
        Environment     = "prod"
    }
