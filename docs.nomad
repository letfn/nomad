job "docs" {
  datacenters = ["jojo.defn.in"]

  group "example" {
    task "server" {
      driver = "docker"

      config {
        image = "hashicorp/http-echo"

        args = [
          "-listen",
          ":5678",
          "-text",
          "hello world",
        ]
      }
    }

    network {
      port "http" {
        static = "5678"
      }
    }
  }
}
