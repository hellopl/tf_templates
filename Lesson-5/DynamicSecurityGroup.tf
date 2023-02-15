# This block defines the provider to use
# In this case, it specifies that the resources will be created in the eu-north-1 region of AWS

provider "aws" {
    region = "eu-north-1"
}

# This block defines an AWS security group resource named "my_test_webserver"
# It includes ingress and egress rules that allow traffic to and from certain ports and IP ranges
# It also includes tags to help identify the resource
resource "aws_security_group" "my_test_webserver" {
  name      = "Dynamic Security Group"


 # This dynamic block creates ingress rules for each port specified in the list
dynamic "ingress" {
for_each = ["80", "443", "8080", "1541", "9092", "9093"]
  content {
    from_port       = ingress.value
    to_port         = ingress.value
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

  # This block creates an ingress rule that allows SSH traffic from the specified IP range
  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    cidr_blocks     = ["10.10.0.0/16"]
  }

  # This block creates an egress rule that allows all traffic to all destinations
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  # These tags help identify the resource
  tags = {
    name = "Dynamic Security Group"
    Owner ="PavelS"
}
}