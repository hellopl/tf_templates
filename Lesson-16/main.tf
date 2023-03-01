provider "aws" {
    region = "eu-north-1"
}

resource "random_string" "rds_password" {
    length              = 12
    special             = true
    override_special    = "!#$&"
}

resource "aws_ssm_parameter" "rds_password" {
    name            = "/prod/mysql"
    description     = "Mastern Password for RDS MySQL"
    type            = "SecureString"
    value           = random_string.rds_password.result
}
