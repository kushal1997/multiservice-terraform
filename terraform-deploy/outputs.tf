output "public_ip" {
  description = "Public IP of the EC2 instance (access frontend at http://<ip>)"
  value       = aws_instance.app.public_ip
}

output "instance_id" {
  description = "EC2 instance id"
  value       = aws_instance.app.id
}
