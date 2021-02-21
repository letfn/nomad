SHELL := /bin/bash

menu:
	@perl -ne 'printf("%20s: %s\n","$$1","$$2") if m{^([\w+-]+):[^#]+#\s(.+)$$}' Makefile

nomad-client-config: # Generate nomad client config
	sudo install -d -o 1000 -g 1000 /mnt
	sudo install -d -o 1000 -g 1000 /mnt/nomad
	cat client.conf | sed 's#x.x.x.x#$(shell ip addr show tailscale0 | grep '/32' | awk '{print $$2}' | cut -d/ -f1)#' > /mnt/nomad/client.conf

nomad-client: # Run nomad client
	nomad agent -config=./mnt/nomad/client.conf -consul-checks-use-advertise -join private.defn.sh -client

nomad-server-config: # Generate nomad server config
	sudo install -d -o 1000 -g 1000 /mnt
	sudo install -d -o 1000 -g 1000 /mnt/nomad
	cat server.conf | sed 's#x.x.x.x#$(shell ip addr show tailscale0 | grep '/32' | awk '{print $$2}' | cut -d/ -f1)#' > /mnt/nomad/server.conf

nomad-dev: # Run nomad dev server
	nomad agent -dev -config=./server.conf -node="$(shell basename $(shell uname -n) .local)" -consul-checks-use-advertise -bootstrap-expect 1

nomad-server: # Run nomad server
	nomad agent -config=./server.conf -node="$(shell basename $(shell uname -n) .local)" -consul-checks-use-advertise -bootstrap-expect 1
