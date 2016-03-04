variable "instance_count" {
  default = 1
}

variable "environment" {}

variable "site" {}

variable "machine_type" {
  default = "n1-standard-1"
}

variable "zone" {
  default = "us-central1-f"
}

variable "image" {}

variable "project" {}
