#
# IPMI Simulator
#

VERSION  := 0.1
IMG_NAME := vaporio/ipmi-simulator


.PHONY: build
build:  ## Build the Docker image for IPMI Simulator
	docker build -f Dockerfile \
		-t  ${IMG_NAME}:latest \
		-t  ${IMG_NAME}:${VERSION} \
		.

.PHONY: run
run: build  ## Build and run the IPMI Simulator locally (localhost:623/udp)
	docker run -d -p 623:623/udp ${IMG_NAME}

.PHONY: version
version:  ## Print the version of IPMI Simulator
	@echo "$(VERSION)"

.PHONY: help
help:  ## Print Make usage information
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z0-9_-]+:.*?## / {printf "\033[36m%-16s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST) | sort

.DEFAULT_GOAL := help
