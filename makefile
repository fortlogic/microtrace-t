#
# Phony targets
#

.PHONY : all clean ctrace outdir test

all : ctrace test

clean : ; rm -rvf build

ctrace : outdir build/libctrace.a

outdir :
	mkdir -p build
	mkdir -p build/CTrace

test : outdir build/tests ; ./build/tests

#
# Variables
#

uname = $(shell uname)

ctrace_c = $(wildcard CTrace/*.c)
ctrace_o = $(addprefix build/,$(ctrace_c:.c=.o))

#
# File targets
#

build/libctrace.a : $(ctrace_o)
ifeq ($(shell uname),Darwin)
	libtool -static -o $@ $^
else
	libtool --tag=CC --mode link clang -static -o $@ $^
endif

build/CTrace/%.o: CTrace/%.c
	clang -c -o $@ $^

build/tests : build ctrace
	swiftc tests/main.swift \
	       -import-objc-header CTrace/ctrace.h \
	       -Lbuild \
	       -lctrace \
	       -o build/tests
