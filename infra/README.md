# Infrastructure for ProgCode Website

## Terraform + Cloud Init

This is the "immutable" stage. Terraform calls DigitalOcean to provision the droplet, floating IP, and block volume for data persistence.

Changes to the `cloud-init` configuration result in recreation of the droplet, as do changes to the `"digitalocean_droplet" "wordpress" {...}` resource

## Docker Compose

By using [Docker contexts](https://dev.to/clavinjune/working-with-remote-docker-using-docker-context-4f52), we should be able to manage the state of our containers using purely CI, without ever SSHing into the machine interactively.

```bash
docker context create \
progcode-wordpress \
--docker "host=ssh://ubuntu@159.89.255.210"
# This assumes we have an `ubuntu` user added
# to the `docker` group
```

Followed by:

```bash
docker context use progcode-wordpress
```