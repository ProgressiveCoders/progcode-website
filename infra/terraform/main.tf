terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
  backend "local" {
    path = "progcode-website-tf-state/website-state.tfstate"
  }
}

data "template_file" "user_data" {
  template = file("cloud-init.yaml")
}
// Passes data via cloud-init
// set docs: https://learn.hashicorp.com/tutorials/terraform/cloud-init

resource "digitalocean_droplet" "wordpress" {
  image  = "ubuntu-22-04-x64"
  name   = "progcode-wordpress"
  region = "nyc3"
  size   = "s-1vcpu-2gb"
  ssh_keys = ["34391351"]
  graceful_shutdown = true
  user_data =  data.template_file.user_data.rendered

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