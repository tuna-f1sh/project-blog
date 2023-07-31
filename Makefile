HOST = krystal
HOST_FOLDER = engineer.john-whittington.co.uk
SHELL := /bin/bash
SITE_FOLDER = _site
DOCKER_RUN := docker run -p 4000:4000 -p 35729:35729 --rm -v "$(shell pwd)":/usr/src/app -u $(shell id -u):$(shell id -g) engineer-blog:latest
SERVE_ARGS := --livereload --drafts --livereload-ignore "_compress_images_cache.yml" --watch
BUILD_ARGS := --destination $(SITE_FOLDER)

.PHONY: serve deploy clean deploy dry-run build optimise image docker-serve docker-build

image:
	# will work on linux/arm64 too but amd64 seems to include the image optimisation tools
	docker build -t engineer-blog . #--platform linux/amd64

docker-serve:
	$(DOCKER_RUN) jekyll serve $(SERVE_ARGS) --force_polling --host 0.0.0.0

docker-build:
	$(DOCKER_RUN) jekyll build $(BUILD_ARGS)

serve:
	bundle exec jekyll serve $(SERVE_ARGS)

build:
	bundle exec jekyll build $(BUILD_ARGS)

dry-run:
	rsync -avP --dry-run $(SITE_FOLDER)/ $(HOST):$(HOST_FOLDER)

deploy:
	rsync -avP $(SITE_FOLDER)/ $(HOST):$(HOST_FOLDER)

clean:
	rm -rf $(SITE_FOLDER)
