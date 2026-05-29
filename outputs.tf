output "instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.hello_server.public_ip
}

output "application_url" {
  description = "URL to access the Hello World application"
  value       = "http://${aws_instance.hello_server.public_ip}:8808"
}

output "vpc_id" {
  description = "ID of the provisioned VPC"
  value       = aws_vpc.main_vpc.id
}

output "vpc_cidr" {
  description = "CIDR block of the VPC"
  value       = aws_vpc.main_vpc.cidr_block
}

output "subnet_cidr" {
  description = "CIDR block of the public subnet"
  value       = aws_subnet.public_subnet.cidr_block
}

output "instance_id" {
  description = "EC2 instance ID — use this to start/stop the instance manually via AWS CLI"
  value       = aws_instance.hello_server.id
}

output "ssh_command" {
  description = "SSH command to connect to the instance"
  value       = "ssh ec2-user@${aws_instance.hello_server.public_ip}"
}
