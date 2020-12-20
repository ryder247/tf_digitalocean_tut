provider "digitalocean" {

}


resource "digitalocean_ssh_key" "web" {
  name       = "Web App SSH Key"
  public_key = file("${path.module}/files/id_rsa.pub")
}

# Create a new Web Droplet in a specified region
resource "digitalocean_droplet" "web" {
  count              = 2
  image              = "ubuntu-18-04-x64"
  name               = "terraform-web-testing-${count.index}"
  region             = "nyc1"
  size               = "s-1vcpu-1gb"
  monitoring         = true
  private_networking = true
  ssh_keys           = [digitalocean_ssh_key.web.id]
  user_data          = file("${path.module}/files/user-data.sh")
}

#Create a load balancer for our site to reduce resources on a single droplet
resource "digitalocean_loadbalancer" "web" {
  name   = "web-lb"
  region = "nyc1"

  forwarding_rule {
    entry_port     = 443
    entry_protocol = "https"

    target_port     = 8080
    target_protocol = "http"


    certificate_id = digitalocean_certificate.web.id
  }

  forwarding_rule {
    entry_port     = 80
    entry_protocol = "http"

    target_port     = 8080
    target_protocol = "http"
  }

  healthcheck {
    port     = 8080
    protocol = "http"
    path     = "/"
  }

  droplet_ids            = digitalocean_droplet.web.*.id
  redirect_http_to_https = true

}

resource "digitalocean_certificate" "web" {
  name    = "web-cert"
  type    = "lets_encrypt"
  domains = [digitalocean_domain.domain.name]
}

# Create a domain for your droplet
resource "digitalocean_domain" "domain" {
  name = "terraform-web-testing.bitnob.com"
}

# Link domain to droplet ipaddress
resource "digitalocean_record" "main" {
  domain = digitalocean_domain.domain.name
  type   = "A"
  name   = "@"
  value  = digitalocean_loadbalancer.web.ip
}

resource "digitalocean_firewall" "web" {
  name = "only-22-80-and-443"

  droplet_ids = digitalocean_droplet.web.*.id

  inbound_rule {
    protocol         = "tcp"
    port_range       = "22"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  inbound_rule {
    protocol                  = "tcp"
    port_range                = "8080"
    source_load_balancer_uids = [digitalocean_loadbalancer.web.id]
  }

  inbound_rule {
    protocol         = "tcp"
    port_range       = "443"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  inbound_rule {
    protocol         = "icmp"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "tcp"
    port_range            = "53"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "udp"
    port_range            = "53"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "icmp"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }
}



