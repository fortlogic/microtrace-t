#
# Symbolic targets
#

.PHONY : all clean libctrace test

all : libctrace test

clean : ; rm -rvf build

libctrace : build/libctrace.a

test : build/tests ; ./build/tests

#
# Variables
#

libctrace_c = $(wildcard libctrace/*.c)
libctrace_o = $(addprefix build/,$(libctrace_c:.c=.o))

#
# File targets
#

build/libctrace.a : $(libctrace_o)
	mkdir -p build
	libtool -static -o $@ $^

build/libctrace/%.o: libctrace/%.c
	mkdir -p build/libctrace
	clang -c -o $@ $^

build/tests : build
	mkdir -p build
	swiftc tests/main.swift -o build/tests
