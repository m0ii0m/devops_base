output "public_ip" {
  value = aws_instance.k3s_server.public_ip
}

output "ssh_command" {
  value = "ssh -i ~/.ssh/k3s-key.pem ubuntu@${aws_instance.k3s_server.public_ip}"
}

output "k3s_kubeconfig_command" {
  value = "ssh -i ~/.ssh/k3s-key.pem ubuntu@${aws_instance.k3s_server.public_ip} 'cat /etc/rancher/k3s/k3s.yaml'"
}
