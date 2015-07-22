provider "google" {}

resource "google_compute_instance" "worker" {
  count = "${var.instance_count}"
  name = "travis-worker-${var.site}-${var.environment}-${count.index}"
  machine_type = "${var.machine_type}"
  zone = "${var.zone}"
  tags = ["worker", "${var.environment}", "${var.site}"]

  disk {
    image = "${var.image}"
    type = "pd-ssd"
  }

  network_interface {
    network = "default"
    access_config {
      # Ephemeral IP
    }
  }

  metadata_startup_script = "${replace(file(\"travis-worker-cloud-init\"), \"___POOL_SIZE___\", \"${var.pool_size}\")}"
}
