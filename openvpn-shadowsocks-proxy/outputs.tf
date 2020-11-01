output "ssh_to_server" {
  value       = "ssh ${local.user}@${aws_instance.instance.public_ip}"
  description = "ssh connection string"
}

output "vpn_usage" {
  value       = "sudo openvpn --config ~/${var.openvpn_client_name}.ovpn"
  description = "vpn usage"
}

output "proxy_usage" {
  value       = <<-EOT
    %{for v in ["", "s"]}
      export http${v}_proxy=http://${var.squid_user}:${var.squid_password}@${aws_instance.instance.public_ip}:${var.squid_port}
    %{endfor}
  EOT
  description = "proxy usage"
}

output "closing_message" {
  value       = "Your <OpenVPN over Shadowsocks> and <HTTP Proxy> are ready!"
  description = "closing message"
}
