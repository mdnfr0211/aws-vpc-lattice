resource "kubernetes_deployment_v1" "nginx" {
  metadata {
    name = "nginx-deployment"
    labels = {
      app = "nginx"
    }
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "nginx"
      }
    }
    template {
      metadata {
        labels = {
          app = "nginx"
        }
      }
      spec {
        container {
          image = "nginx:1.25.3"
          name  = "nginx"
          resources {
            limits = {
              cpu    = "1"
              memory = "500Mi"
            }
            requests = {
              cpu    = "500m"
              memory = "250Mi"
            }
          }
        }
        toleration {
          key      = "app"
          operator = "Equal"
          value    = "nginx"
          effect   = "NoSchedule"
        }
        node_selector = {
          app = "nginx"
        }
      }
    }
  }

  depends_on = [
    kubectl_manifest.karpenter_nodepool
  ]
}

resource "kubernetes_service_v1" "nginx" {
  metadata {
    name = "nginx-service"
  }
  spec {
    selector = {
      app = kubernetes_deployment_v1.nginx.metadata[0].labels.app
    }
    session_affinity = "ClientIP"
    port {
      protocol    = "TCP"
      port        = 80
      target_port = 80
    }
    type = "ClusterIP"
  }
}
