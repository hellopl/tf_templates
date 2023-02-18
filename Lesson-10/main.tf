provider "aws" {
    region = "eu-central-1"
}

# owner account ID  099720109477
# ami-0d1ddd83282187d18 x86

data "aws_ami" "latest_ubuntu" {
    owners      = ["099720109477"]
    most_recent = true
    filter {
        name    = "name"
        values   = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
    }
}


output "latest_ubuntu_ami_id" {
  value       = data.aws_ami.latest_ubuntu.id
}

output "latest_ubuntu_ami_name" {
  value       = data.aws_ami.latest_ubuntu.name
}
