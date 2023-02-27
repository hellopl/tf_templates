output "my_static_ip" {                 #public_IP
    value       = aws_eip.my_static_ip.public_ip
}