# resource "random_id" "bucket_prefix" {
#   byte_length = 3
# }
resource "google_project_service" "functionsapi" {
  project = var.project_id
  service = "cloudfunctions.googleapis.com"
}
resource "google_project_service" "runapi" {
  project = var.project_id
  service = "run.googleapis.com"
}
resource "google_project_service" "buildapi" {
  project = var.project_id
  service = "cloudbuild.googleapis.com"
}
resource "google_project_service" "arapi" {
  project = var.project_id
  service = "artifactregistry.googleapis.com"
}
# resource "google_storage_bucket" "bucket" {
#   project = var.project_id
#   name                        = "${random_id.bucket_prefix.hex}-gcf-source" # Every bucket name must be globally unique
#   location                    = "asia"
#   uniform_bucket_level_access = true
# }

# resource "google_storage_bucket_object" "object" {
  
#   name   = "function-source.zip"
#   bucket = google_storage_bucket.bucket.name
#   source = "function-source.zip" # Add path to the zipped function source code
# }

resource "google_cloudfunctions2_function" "function" {
  project = var.project_id
  name        = var.gen2_function_name
  location    = var.gen2_function_location


  build_config {
    runtime     = var.gen2_function_runtime
    entry_point = var.gen2_function_entry_point # Set the entry point
    source {
      storage_source {
        bucket = var.gen2_function_bucket
        object = var.gen2_function_object
      }
    }
  }

  service_config {
    max_instance_count = var.gen2_function_max_instance_count
    available_memory   = var.gen2_function_max_available_memory
    timeout_seconds    = var.gen2_function_max_timeout_seconds
  }
}

output "function_uri" {
  value = google_cloudfunctions2_function.function.service_config[0].uri
}