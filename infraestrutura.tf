# Criando a instância EC2
resource "aws_instance" "app_instance" {
  ami           = data.aws_ami.ubuntu.id  # Ubuntu Jammy
  instance_type = "t2.micro"
 
  tags = {
    Name = "AppInstance"
  }

  # Grupo de segurança
  security_groups = [aws_security_group.sg.name]

  # Definindo o volume de armazenamento
  root_block_device {
    volume_size = 8
    volume_type = "gp2"
  }
}

# Security group
resource "aws_security_group" "sg" {
  name        = "app_sg"
  description = "Security Group para EC2"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Provisionamento dos containers (usando Docker)
resource "docker_image" "nginx_image" {
  name = "nginx:latest"
  build {
    context    = "."  # Diretório atual
    dockerfile = "./Dockerfile-nginx"  # Caminho do Dockerfile para a imagem do Nginx
  }
}

resource "docker_image" "proxy_image" {
  name = "nginx:latest"
  build {
    context    = "."  # Diretório atual
    dockerfile = "./Dockerfile-proxy"  # Caminho do Dockerfile para a imagem do proxy reverso
  }
}

resource "docker_container" "nginx_container" {
  name  = "nginx-app"
  image = docker_image.nginx_image.name  # Usando o nome da imagem diretamente
  ports {
    internal = 80
    external = 80
  }
}

resource "docker_container" "proxy_container" {
  name  = "nginx-proxy"
  image = docker_image.proxy_image.name  # Usando o nome da imagem diretamente
  ports {
    internal = 80
    external = 8080
  }
}