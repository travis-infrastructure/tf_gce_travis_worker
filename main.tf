provider "google" {}

resource "template_file" "worker_cloud_init" {
  filename = "cloud-init/travis-worker-${var.site}-${var.environment}"
  count = "${var.instance_count}"
  vars {
    pool_size = "${var.pool_size}"
    number = "${count.index}"
  }
}

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

  metadata_startup_script = "${element(template_file.worker_cloud_init.*.rendered, count.index)}"
}
