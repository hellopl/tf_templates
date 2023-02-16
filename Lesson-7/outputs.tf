output "mywebserver_instance_id" {
    value       = aws_instance.my_test_webserver.id
  }

output "mywebserver_public_ip_address" {
    value       = aws_eip.my_static_ip.public_ip
  }

output "mywebserver_sg_id" {
    value       = aws_security_group.my_test_webserver.id
  }

output "mywebserver_sg_arn" {
    value       = aws_security_group.my_test_webserver.arn
  }  