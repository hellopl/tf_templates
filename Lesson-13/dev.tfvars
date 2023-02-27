#autofill parameters for DEV

region                          = "eu-north-1"
instance_type                   = "t4g.small"
enable_detailed_monitoring      = false

allow_ports                     = ["80", "22", "443"]

common_tags = {
        Owner           ="PavelS"
        Project         = "T1000"
        CostCenter      = "007"
        Environment     = "dev"
    }
