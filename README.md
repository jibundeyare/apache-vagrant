# Apache Vagrant

This repository contains virtual machines that run some useful setups :

- `apache-vagrant-single-vhost` runs apache with a single virtual host
- `apache-vagrant-multi-vhost` runs apache with multiple virtual hosts
- `apache-vagrant-single-vhost-ssl` runs apache with a single virtual host with HTTPS

## Settings

### IP

All virtual machines are set configured to run with the IP address `192.168.33.10`.

- `apache-vagrant-single-vhost` is not bound to a particular IP address
- `apache-vagrant-multi-vhost` is not bound to a particular IP address
- `apache-vagrant-single-vhost-ssl` is bound to the IP address `192.168.33.10`

### Domain names

- `apache-vagrant-single-vhost` is not bound to a particular domain name
- `apache-vagrant-multi-vhost` is bound to the domain names : `monsite1.local` and `monsite2.local`
- `apache-vagrant-single-vhost-ssl` is not bound to a particular domain name

### PhpMyAdmin

- login: `admin`
- password: `123`

## Versions

- VirtualBox 5.2.12r12257
- ruby 2.5.1p57
- Vagrant 2.1.1

- Debian GNU/Linux 9 Stretch v9.3.0 (https://app.vagrantup.com/debian/boxes/stretch64)
- apache 2.4.25-3+deb9u3
- mysql-server 5.5.9999+default
- php 7.0.27-0+deb9u1
- openssl 1.1.0f-3+deb9u1

