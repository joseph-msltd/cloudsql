resource "google_storage_bucket" "source_files" {
  name     = var.bucket_name
  location = "US"
}

resource "google_storage_bucket_object" "bq_objects" {
  for_each   = fileset("${path.module}/resources", "**")
  depends_on = [google_storage_bucket.source_files]
  name       = each.key
  source     = "./resources/${each.key}"
  bucket     = var.bucket_name
}