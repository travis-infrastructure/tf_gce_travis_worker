provider "google" {}

resource "google_compute_instance" "worker" {
  count = "${var.instance_count}"
  name = "travis-worker-gce-${var.site}-${var.environment}-${count.index + 1}"
  machine_type = "${var.machine_type}"
  zone = "${var.zone}"
  tags = ["worker", "${var.environment}", "${var.site}"]

  can_ip_forward = false

  disk {
    auto_delete = true
    image = "${var.image}"
    type = "pd-ssd"
  }

  network_interface {
    network = "default"
    access_config {
      # Ephemeral IP
    }
  }

  metadata_startup_script = "${file("cloud-init/travis-worker-gce-${var.site}-${var.environment}")}
}
