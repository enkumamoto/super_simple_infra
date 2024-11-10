output "instance_public_ip" {
  description = "Endereço IP público da instância EC2"
  value       = aws_instance.app_instance.public_ip
}

# output "nginx_container_ip" {
#   description = "Endereço IP do container Nginx"
#   value       = docker_container.nginx_container.instance_public_ip
# }