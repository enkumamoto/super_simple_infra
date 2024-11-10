# Configuração de rede entre os containers
resource "docker_network" "monitoring_network" {
  name = "monitoring_network"
}

# Provisionamento dos containers (usando Docker)
resource "docker_image" "prometheus_image" {
  name = "prometheus:latest"
  build {
    context    = "."  # Diretório atual
    dockerfile = "./Dockerfile-prometheus"  # Caminho do Dockerfile para a imagem do Prometheus
  }
}

resource "docker_container" "prometheus_container" {
  name  = "prometheus"
  image = docker_image.prometheus_image.name
  
  networks_advanced {
    name = docker_network.monitoring_network.name
  }

  ports {
    internal = 9090
    external = 9090
  }
}

resource "docker_image" "grafana_image" {
  name = "grafana:latest"
  build {
    context    = "."  # Diretório atual
    dockerfile = "./Dockerfile-grafana"  # Caminho do Dockerfile para a imagem do Grafana
  }
}

# Provisionamento do container Grafana
resource "docker_container" "grafana_container" {
  name  = "grafana"
  image = docker_image.grafana_image.name

  networks_advanced {
    name = docker_network.monitoring_network.name
  }

  ports {
    internal = 3000
    external = 3000
  }
}