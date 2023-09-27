# create ns
resource "kubernetes_namespace" "example" {
  metadata {
    annotations = {
      name = "example-annotation"
    }

    labels = {
      mylabel = "label-value"
    }

    name = "terraform-example-namespace"
  }
}

resource "kubernetes_pod" "test" {
  metadata {
    name      = "terraform-example-pod"
    namespace = kubernetes_namespace.example.metadata.0.name
  }

  spec {
    container {
      image = "nginx:1.21.6"
      name  = "example"
    }
  }
}
