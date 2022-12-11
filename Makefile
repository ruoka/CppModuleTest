.DEFAULT_GOAL := all

CXX := /usr/lib/llvm-15/bin/clang++

CXXFLAGS := -std=c++20 -fprebuilt-module-path=.

SOURCES := $(wildcard *.c++) $(wildcard *.c++m)

OBJECTS := $(SOURCES:%.c++=%.o)
OBJECTS := $(OBJECTS:%.c++m=%.o)

%.pcm: %.c++m
	$(CXX) $(CXXFLAGS) --precompile -c -o $@ $<

%.o: %.pcm
	$(CXX) $(CXXFLAGS) -c -o $@ $<

%.o: %.c++
	$(CXX) $(CXXFLAGS) -c -o $@ $<

main: $(OBJECTS)
	$(CXX) $(CXXFLAGS) -o $@ $^

test.d:
	rm -f test.d
#c++
	grep -H -E '\s*import\s*([a-z_0-9]+)' *.c++ | sed -E 's/(^[a-z_0-9]+)\.c\+\+:\s*import\s*([a-z_0-9]+);/\1.o: \2.pcm/' > test.d
#c++ partition
	grep -H -E '\s*import\s*:([a-z_0-9]+)' *.c++ | sed -E 's/(^[a-z_0-9]+)\.c\+\+:\s*import\s*([a-z_0-9]+);/\1.o: \1-\2.pcm/' >> test.d
#c++m
	grep -H -E '\s*import\s*([a-z_0-9]+)' *.c++m | sed -E 's/(^[a-z_0-9]+)\.c\+\+m:.*import\s*([a-z_0-9]+);/\1.pcm: \2.pcm/' >> test.d
#c++m partition
	grep -H -E '\s*import\s*:([a-z_0-9]+)' *.c++m | sed -E 's/(^[a-z_0-9]+)\.c\+\+m:.*import\s*:([a-z_0-9]+);/\1.pcm: \1-\2.pcm/' >> test.d

-include test.d

.PHONY: clean
clean:
	rm -f *.o *.pcm *.d main

.PHONY: all
all: test.d main

.PHONY: info
info:
	@echo $(SOURCES)
	@echo $(OBJECTS)
