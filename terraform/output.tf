

output "server_public_dsn" {
  value = aws_instance.sag_cc_spm_server.public_dns
}

output "server_arn" {
  value = aws_instance.sag_cc_spm_server.arn
}


output "server_host" {
  value = aws_instance.sag_cc_spm_server.host_id
}