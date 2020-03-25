SHELL := /bin/bash
# ---------------------------------------------------------------------------- #
#	Local commands 
# ---------------------------------------------------------------------------- #
.PHONY: clean

all:
	./bootstrap.sh

clean:
	rm -f .dotlock

# ---------------------------------------------------------------------------- #
#	Docker commands
# ---------------------------------------------------------------------------- #
.PHONY: build test start

# Build and tag docker image
build:
	docker build . -t dotfiles:latest

# Run tests in docker container
# @arg $TARGET binary to install and test
test:
	docker build . -t dotfiles:localtest \
		--build-arg TARGET=$$TARGET \
	&& docker run dotfiles:localtest

# Launch bash in docker container
start:
	docker run -it dotfiles:latest /bin/bash
