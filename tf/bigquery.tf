resource "google_bigquery_dataset" "manufacturer_dataset" {
  dataset_id = var.dataset_name
  location   = "US"
}

resource "google_bigquery_table" "fault_detection" {
  depends_on = [google_bigquery_dataset.manufacturer_dataset,
  google_storage_bucket_object.bq_objects]
  dataset_id = google_bigquery_dataset.manufacturer_dataset.dataset_id
  table_id   = "fault_detection"

  external_data_configuration {
    autodetect    = true
    source_format = "CSV"

    source_uris = [
      "gs://wegcpsqlresources/fault/*",
    ]
  }
}

resource "google_bigquery_table" "product_info" {
  depends_on = [google_bigquery_dataset.manufacturer_dataset,
  google_storage_bucket_object.bq_objects]
  dataset_id = google_bigquery_dataset.manufacturer_dataset.dataset_id
  table_id   = "product_info"

  external_data_configuration {
    autodetect    = true
    source_format = "CSV"

    source_uris = [
      "gs://wegcpsqlresources/product/*",
    ]
  }
}