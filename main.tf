provider "google" {}

resource "template_file" "worker_cloud_init" {
  filename = "cloud-init/travis-worker-gce-${var.site}-${var.environment}"
  count = "${var.instance_count}"

  lifecycle {
    create_before_destroy = true
  }

  vars {
    number = "${count.index + 1}"
  }
}

resource "google_compute_instance" "worker" {
  count = "${var.instance_count}"
  name = "travis-worker-gce-${var.site}-${var.environment}-${count.index + 1}"
  machine_type = "${var.machine_type}"
  zone = "${var.zone}"
  tags = ["worker", "${var.environment}", "${var.site}"]

  lifecycle {
    create_before_destroy = true
  }

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
