output "public_ip" {
  value = aws_instance.jumpbox.public_ip
}

output "galera_ips" {
  description = "Should be a list of cluster IPs"
  value = join(",", aws_instance.galera_db[*].private_ip)
}

output "maxscale_ips" {
  description = "Maxscale IP Addresses"
  value = join(",", aws_instance.maxscale[*].private_ip)
}