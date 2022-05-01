terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

resource "digitalocean_droplet" "wordpress" {
  image  = "ubuntu-22-04-x64"
  name   = "progcode-wordpress"
  region = "nyc3"
  size   = "s-1vcpu-2gb"
}

resource "digitalocean_volume" "wp-data" {
  region = "nyc3"
  name = "wp-data"
  size = "5"
  initial_filesystem_type = "ext4"
  description = "Wordpress content library and /var/lib/mysql"
}

resource "digitalocean_volume_attachment" "foobar" {
  droplet_id = digitalocean_droplet.wordpress.id
  volume_id  = digitalocean_volume.wp-data.id
}