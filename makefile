#
# Symbolic targets
#

.PHONY : all clean clib examples test

all : clib examples test

clean :
	rm -rvf build

clib : build/libctrace.a

examples :

test :

#
# File targets
#

build :
	mkdir -p build

build/libctrace.a : build

