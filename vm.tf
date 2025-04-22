resource "google_compute_address" "static_public" {
  name = join("-", ["external-ip", "wireguard", "vm"])
}

resource "google_compute_instance" "vm" {
  for_each     = var.vm
  name         = each.value.name
  machine_type = each.value.machine_type
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = each.value.boot_disk.initialize_params.image
      size  = each.value.boot_disk.initialize_params.size
      type  = each.value.boot_disk.initialize_params.type
    }
  }

  metadata_startup_script = file("setup.sh")
  network_interface {
    network = each.value.network_interface.network
    access_config {
      nat_ip = google_compute_address.static_public.address
    }
  }

  scheduling {
    preemptible        = each.value.scheduling.preemptible
    automatic_restart  = each.value.scheduling.automatic_restart
    provisioning_model = each.value.scheduling.provisioning_model
  }

  allow_stopping_for_update = each.value.allow_stopping_for_update

  desired_status = each.value.desired_status

  tags = each.value.tags

  depends_on = [google_compute_address.static_public]
}