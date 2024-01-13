terraform {
  required_providers {
    docker = {
        source = "kreuzwerker/docker"
        version = "3.0.2"
    }
  }
}

resource "docker_image" "nginx" {
  name = "nginx:latest"
}

resource "docker_container" "webserver" {
  count = 3
  name = "webserver${count.index}"
  image = docker_image.nginx.image_id
  ports {
    internal = 80
    external = "800${count.index}"
  }

  volumes {
    host_path = "${path.cwd}/index.html"
    container_path = "/usr/share/nginx/html/index.html"
  }
}

resource "docker_container" "proxy" {
    name = "proxy"
    image = docker_image.nginx.image_id
    ports {
        internal = 80
        external = 8080
    }

    volumes {
        host_path = "${path.cwd}/proxy.conf"
        container_path = "/etc/nginx/conf.d/default.conf"
    }
}

