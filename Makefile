SHELL := /bin/bash

menu:
	@perl -ne 'printf("%20s: %s\n","$$1","$$2") if m{^([\w+-]+):[^#]+#\s(.+)$$}' Makefile

nomad-dev: # Run dev server
	nomad agent -config=./dev.conf -node="$(shell basename $(shell uname -n) .local)" -consul-checks-use-advertise -bootstrap-expect 1

nomad-server: # Run nomad server
	nomad agent -config=./server.conf -node="$(shell basename $(shell uname -n) .local)" -consul-checks-use-advertise -bootstrap-expect 1

nomad-demo: # Subit nomad job
	nomad job run docs.nomad
