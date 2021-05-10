HOST = krystal
HOST_FOLDER = engineer.john-whittington.co.uk
SHELL := /bin/bash
SITE_FOLDER = _site

.PHONY: serve deploy clean deploy dry-run build optimise

serve:
	bundle exec jekyll serve --livereload

build:
	bundle exec jekyll build --destination $(SITE_FOLDER)

optimise:
	imageoptim $(SITE_FOLDER)/assets

dry-run: build
	rsync -avP --delete --dry-run $(SITE_FOLDER)/ $(HOST):$(HOST_FOLDER)

deploy: build
	rsync -avP --delete $(SITE_FOLDER)/ $(HOST):$(HOST_FOLDER)

clean:
	rm -rf $(SITE_FOLDER)
