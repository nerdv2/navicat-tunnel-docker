job "navicat-tunnel" {
  datacenters = ["dc1"]
  type        = "service"

  group "web" {
    count = 1

    network {
      port "http" {
        to = 80
      }
    }

    service {
      name     = "navicat-tunnel"
      port     = "http"
      provider = "nomad"

      check {
        type     = "http"
        name     = "navicat-tunnel-check"
        path     = "/"
        interval = "30s"
        timeout  = "5s"
      }
    }

    restart {
      attempts = 3
      interval = "2m"
      delay    = "15s"
      mode     = "fail"
    }

    task "app" {
      driver = "docker"

      config {
        image = "ghcr.io/nerdv2/navicat-tunnel-docker:latest"
        ports = ["http"]
      }

      env {
        ALLOW_TEST_MENU = "true"
        # Optional HTTP Basic Authentication:
        # HTTP_AUTH_USER = "admin"
        # HTTP_AUTH_PASS = "supersecret"
      }

      resources {
        cpu    = 100
        memory = 128
      }
    }
  }
}
