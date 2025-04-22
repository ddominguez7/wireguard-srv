output "instance_names" {
  value = [for vm in google_compute_instance.vm : vm.name]
}

output "instance_external_ips" {
  value = [for vm in google_compute_instance.vm : vm.network_interface[0].access_config[0].nat_ip]
}