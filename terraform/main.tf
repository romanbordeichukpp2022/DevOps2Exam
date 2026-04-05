# 1. VPC
resource "digitalocean_vpc" "bordeichuk_vpc" {
  name     = "bordeichuk-vpc"
  region   = "fra1"
  ip_range = "10.10.10.0/24"
}

# 2. Firewall
resource "digitalocean_firewall" "bordeichuk_fw" {
  name = "bordeichuk-firewall"

  droplet_ids = [digitalocean_droplet.bordeichuk_node.id]

  inbound_rule {
    protocol         = "tcp"
    port_range       = "22"
    source_addresses = ["0.0.0.0/0"]
  }

  inbound_rule {
    protocol         = "tcp"
    port_range       = "80"
    source_addresses = ["0.0.0.0/0"]
  }

  inbound_rule {
    protocol         = "tcp"
    port_range       = "443"
    source_addresses = ["0.0.0.0/0"]
  }

  # Додаткові порти 8000-8003
  dynamic "inbound_rule" {
    for_each = ["8000", "8001", "8002", "8003"]
    content {
      protocol         = "tcp"
      port_range       = inbound_rule.value
      source_addresses = ["0.0.0.0/0"]
    }
  }

  outbound_rule {
    protocol                = "tcp"
    port_range              = "1-65535"
    destination_addresses   = ["0.0.0.0/0"]
  }
}

# 3. VM (Droplet) - 2 vCPU, 4GB RAM для Minikube
resource "digitalocean_droplet" "bordeichuk_node" {
  name     = "bordeichuk-node"
  region   = "fra1"
  size     = "s-2vcpu-4gb" # Системні вимоги для K8s
  image    = "ubuntu-24-04-x64"
  vpc_uuid = digitalocean_vpc.bordeichuk_vpc.id
}

# 4. Bucket (Space)
resource "digitalocean_spaces_bucket" "bordeichuk_bucket" {
  name   = "bordeichuk-app-storage-2026"
  region = "fra1"
  acl    = "private"
}