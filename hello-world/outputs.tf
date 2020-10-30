output "ssh_connection" {
  value       = "ssh ${local.user}@${aws_instance.instance.public_ip}"
  description = "ssh connection string"
}

output "closing_message" {
  value       = "Your instance is ready!"
  description = "closing message"
}
