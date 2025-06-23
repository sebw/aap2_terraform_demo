output "public_ip" {
  value = aws_instance.rhel.public_ip
  description = "The public IP address of the EC2 instance"
}

