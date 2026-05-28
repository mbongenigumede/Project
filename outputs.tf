output "instance_public_ip" {
  description = "EC2 Public IP"
  value       = aws_instance.hello_server.public_ip
}

output "application_url" {
  description = "Hello World Application URL"
  value       = "http://${aws_instance.hello_server.public_ip}:8808"
}