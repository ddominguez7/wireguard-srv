variable "project" {
  description = "The GCP project ID to deploy resources into."
  type        = string
}

variable "region" {
  description = "The GCP region to deploy resources into."
  type        = string
}

variable "zone" {
  description = "The GCP zone within the specified region to deploy resources into."
  type        = string
}

variable "firewall_rule" {
  type = map(object({
    name          = string
    network       = string
    protocol      = string
    ports         = list(string)
    target_tags   = list(string)
    source_ranges = list(string)
  }))
}

variable "vm" {
  type = map(object({
    name         = string
    machine_type = string
    boot_disk = object({
      initialize_params = object({
        image = string
        size  = number
        type  = string
      })
    })
    network_interface = object({
      network = string
    })
    scheduling = object({
      preemptible        = bool
      automatic_restart  = bool
      provisioning_model = string
    })
    tags                      = list(string)
    allow_stopping_for_update = bool
    desired_status            = string
  }))
}