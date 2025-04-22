# Deploy a WireGuard Server on GCP with Terraform

## Objectives

- **Infrastructure as Code with Terraform**: Automate the creation and configuration of infrastructure.
- **WireGuard Server Deployment**: Set up a VM optimized for WireGuard, with the necessary configurations.
- **Network & Firewall Setup**: Ensure the required ports are open for WireGuard's operation.
- **Instance Management**: Easily manage and remove instances as needed.
- **Secure Access with IAP**: The instance does **not** expose SSH (port 22) to the entire internet. Instead, Identity-Aware Proxy (IAP) will be used for secure access.

## What is WireGuard?

WireGuard is a modern VPN protocol known for its simplicity, security, and performance. It operates at the kernel level to ensure efficient encryption and data transmission.

### Key Features:
- **Performance**: Faster than traditional VPN solutions due to streamlined cryptographic processing.
- **Security**: Uses strong cryptography to protect communications.
- **Simplicity**: Minimalist design with fewer components prone to misconfiguration.
- **Cross-platform**: Runs on Linux, Windows, macOS, iOS, and Android.

## Directory Structure

### Instance Configuration
The following configuration defines a standard instance optimized for WireGuard, including open ports required for operation. **Importantly, SSH access (port 22) is restricted and will not be exposed to the entire internet. Instead, Identity-Aware Proxy (IAP) will be used to securely access the instance.** This enhances security by preventing unauthorized access while allowing controlled, authenticated connections.

```plaintext
wireguard-srv/
├── provider.tf
├── variables.tf
├── vm.tf
├── output.tf
└── rule.tf




project = "gcp_project_id_"
region  = "gcp_region"
zone    = "gcp_zone"

vm = {
  vm_01 = {
    name         = "wireguard-srv"
    machine_type = "e2-micro"
    boot_disk = {
      initialize_params = {
        image = "ubuntu-os-cloud/ubuntu-2204-lts"
        size  = 10
        type  = "pd-standard"
      }
    }
    network_interface = {
      network = "default"
    }
    scheduling = {
      automatic_restart = true
      preemptible      = false
      provisioning_model = "STANDARD"
    }
    tags                      = ["infrastructure", "ssh", "docker", "wireguard"]
    allow_stopping_for_update = true
    desired_status            = "RUNNING"
  }
}

firewall_rule = {
  "wireguard-tcp" = {
    name          = "wireguard-tcp"
    network       = "default"
    protocol      = "tcp"
    ports         = ["8000", "80", "443"]
    target_tags   = ["wireguard"]
    source_ranges = ["0.0.0.0/0"]
  }
  "wireguard-udp" = {
    name          = "wireguard-udp"
    network       = "default"
    protocol      = "udp"
    ports         = ["51820"]
    target_tags   = ["wireguard"]
    source_ranges = ["0.0.0.0/0"]
  }
  "wireguard-iap" = {
    name          = "wireguard-iap"
    network       = "default"
    protocol      = "tcp"
    ports         = ["22"]
    target_tags   = ["wireguard"]
    source_ranges = ["35.235.240.0/20"]
  }
}