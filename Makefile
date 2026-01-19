PLATFORM	?= x86_64-linux-gnu
BUILD		?= release

topdir		:= $(patsubst %/,%,$(dir $(abspath $(lastword $(MAKEFILE_LIST)))))
builddir	= $(topdir)/targets/$(PLATFORM)/build
installdir	= $(topdir)/targets/$(PLATFORM)/install

ifeq ($(BUILD),release)
override CMAKEFLAGS		+= -DCMAKE_BUILD_TYPE=MinSizeRel
endif
ifeq ($(BUILD),debug)
override CMAKEFLAGS		+= -DCMAKE_BUILD_TYPE=Debug
override CMAKEFLAGS		+= -DCMAKE_VERBOSE_MAKEFILE=ON
override CMAKEFLAGS		+= -DCMAKE_FIND_DEBUG_MODE=ON
endif
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
