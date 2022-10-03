resource "google_cloud_run_service" "default" {

  project  = var.project
  location = var.location
  name     = "registry-proxy"

  template {
    spec {
      containers {
        image = "gcr.io/test-env/registry-proxy"
        env {
          name = "REGISTRY_HOST"
          value = "index.docker.io"
        }
        env {
          name = "REPO_PREFIX"
          value = "test"
        }
      }
    }
  }
  traffic {
    percent         = 100
    latest_revision = true
  }
}

data "google_iam_policy" "noauth" {
  binding {
    role = "roles/run.invoker"
    members = [
      "allUsers",
    ]
  }
}

resource "google_cloud_run_service_iam_policy" "noauth" {
  location    = google_cloud_run_service.default.location
  project     = google_cloud_run_service.default.project
  service     = google_cloud_run_service.default.name

  policy_data = data.google_iam_policy.noauth.policy_data
}

resource "google_cloud_run_domain_mapping" "default" {
  project  = var.project
  location = var.location
  name     = "registry.test.com"

  metadata {
    namespace = var.project
  }
  spec {
    route_name = google_cloud_run_service.default.name
  }
}