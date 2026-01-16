PLATFORM	?= x86_64-linux-gnu

topdir		:= $(patsubst %/,%,$(dir $(abspath $(lastword $(MAKEFILE_LIST)))))
builddir	= $(topdir)/targets/$(PLATFORM)/build
installdir	= $(topdir)/targets/$(PLATFORM)/install

override CMAKEFLAGS		+= -DCMAKE_BUILD_TYPE=MinSizeRel
override CMAKEFLAGS		+= -DCMAKE_INSTALL_PREFIX=$(installdir)
override CMAKEFLAGS		+= -DCMAKE_PREFIX_PATH=$(installdir)
override CMAKEFLAGS		+= -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
override CMAKEFLAGS		+= --toolchain $(topdir)/cmake/toolchains/$(PLATFORM).cmake


.PHONY: all build build-test launch clean
.DEFAULT_GOAL = all

all: build build-test

build:
	cmake -S $(topdir)/src -B $(builddir)/src $(CMAKEFLAGS)
	cmake --build $(builddir)/src
	cmake --install $(builddir)/src

build-test:
	cmake -S $(topdir)/test -B $(builddir)/test $(CMAKEFLAGS)
	cmake --build $(builddir)/test
	cmake --install $(builddir)/test

launch:
	$(installdir)/bin/lib_test_app

clean:
	$(RM) -r targets
