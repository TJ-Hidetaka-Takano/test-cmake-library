DEPS		= .env
V			?= 0

ifeq ($(shell expr $V \> 0),1)
MKARGS		+= BUILD=debug
endif

.PHONY: all build build-test launch clean pre-commit
.DEFAULT_GOAL = all

all: $(DEPS) build build-test

build: $(DEPS)
	docker compose run --rm sdk make -f Makefile $(MKARGS) $@

build-test: $(DEPS)
	docker compose run --rm sdk make -f Makefile $(MKARGS) $@

launch: $(DEPS)
	docker compose run --rm sdk make -f Makefile $(MKARGS) $@

clean: $(DEPS)
	docker compose run --rm sdk make -f Makefile $(MKARGS) $@

pre-commit: $(DEPS)
	docker compose run --rm utility pre-commit run -a

.env:
	@echo "UID=$(shell id -u)" > $@
	@echo "GID=$(shell id -g)" >> $@
