HOST = krystal
HOST_FOLDER = engineer.john-whittington.co.uk
SHELL := /bin/bash
SITE_FOLDER = _site

.PHONY: serve deploy clean deploy dry-run build optimise

serve:
	bundle exec jekyll serve --livereload --drafts --livereload-ignore "_compress_images_cache.yml"

build:
	bundle exec jekyll build --destination $(SITE_FOLDER)

dry-run: build
	rsync -avP --dry-run $(SITE_FOLDER)/ $(HOST):$(HOST_FOLDER)

deploy: build
	rsync -avP $(SITE_FOLDER)/ $(HOST):$(HOST_FOLDER)

clean:
	rm -rf $(SITE_FOLDER)