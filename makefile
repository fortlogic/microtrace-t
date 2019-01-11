#
# Phony targets
#

.PHONY : all clean libctrace outdir test

all : libctrace test

clean : ; rm -rvf build

libctrace : outdir build/libctrace.a

outdir :
	mkdir -p build
	mkdir -p build/libctrace

test : outdir build/tests ; ./build/tests

#
# Variables
#

uname = $(shell uname)

libctrace_c = $(wildcard libctrace/*.c)
libctrace_o = $(addprefix build/,$(libctrace_c:.c=.o))

#
# File targets
#

build/libctrace.a : $(libctrace_o)
ifeq ($(shell uname),Darwin)
	libtool -static -o $@ $^
else
	libtool --tag=CC --mode link clang -static -o $@ $^
endif

build/libctrace/%.o: libctrace/%.c
	clang -c -o $@ $^

build/tests : build libctrace
	swiftc tests/main.swift \
	       -import-objc-header libctrace/ctrace.h \
	       -Lbuild \
	       -lctrace \
	       -o build/tests
