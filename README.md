# Projeto de Infraestrutura AWS com Terraform

Este projeto utiliza Terraform para configurar uma infraestrutura na Amazon Web Services (AWS), incluindo uma instância EC2, grupos de segurança, e contêineres Docker para uma aplicação web. Também inclui arquivos de configuração para Nginx e um setup de proxy reverso.

## Estrutura do Projeto

O projeto consiste nos seguintes arquivos principais:

### infraestrutura.tf

Este arquivo Terraform define os recursos principais da nossa infraestrutura:

- Cria uma instância EC2 com Ubuntu Jammy como sistema operacional
- Configura um grupo de segurança permitindo tráfego de entrada nas portas 22 (SSH) e 80 (HTTP)
- Constrói imagens Docker para Nginx e um proxy reverso
- Cria contêineres Docker para Nginx e o proxy reverso

Recursos-chave incluem:
- aws_instance "app_instance"
- aws_security_group "sg" 
- docker_image "nginx_image"
- docker_image "proxy_image"
- docker_container "nginx_container"
- docker_container "proxy_container"

### Dockerfile-nginx

Este Dockerfile constrói uma imagem de Nginx:

dockerfile FROM nginx:latest COPY index.html /usr/share/nginx/html/index.html


Ele copia um arquivo `index.html` para o contêiner Nginx, que servirá como nossa página web.

### Dockerfile-proxy

Este Dockerfile constrói uma imagem de proxy reverso:

dockerfile FROM nginx:latest COPY default.conf /etc/nginx/conf.d/default.conf


Ele copia um arquivo de configuração `default.conf` para o contêiner Nginx, configurando a funcionalidade do proxy reverso.

### default.conf

Este arquivo de configuração define o comportamento do proxy reverso:

nginx server { listen 80;

location / {
    proxy_pass http://nginx-app:80;
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
}
}


Ele configura o proxy reverso para encaminhar requisições para o contêiner de aplicação Nginx.

### main.tf

Este arquivo Terraform está atualmente vazio. Deve ser preenchido com recursos adicionais ou configurações necessárias para o projeto.

### outputs.tf

Este arquivo define valores de saída para o estado Terraform:

hcl output "instance_public_ip" { description = "Endereço IP público da instância EC2" value = aws_instance.app_instance.public_ip }

Comente e ajuste a seguinte linha se você quiser sair o IP do contêiner Nginx:
output "nginx_container_ip" {
description = "Endereço IP do container Nginx"
value = docker_container.nginx_container.instance_public_ip
}

Atualmente, ele só sai o IP público da instância EC2.

### variables.tf

Este arquivo define variáveis para a configuração Terraform:

hcl variable "instance_type" { description = "Tipo da instância EC2" default = "t2.micro" }

variable "aws_region" { description = "Região da AWS" default = "us-east-1" }


Ele define valores padrão para o tipo da instância EC2 e a região da AWS.

## Como Usar

1. Certifique-se de ter instalado e configurado o Terraform com suas credenciais da AWS.
2. Execute `terraform init` para inicializar o diretório de trabalho.
3. Execute `terraform plan` para ver o plano de execução.
4. Execute `terraform apply` para criar a infraestrutura.

Nota: Revise e ajuste os arquivos de configuração conforme necessário antes de aplicar as alterações em produção.