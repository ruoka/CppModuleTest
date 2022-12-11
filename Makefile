.DEFAULT_GOAL := all

CXX := /usr/lib/llvm-15/bin/clang++

CXXFLAGS := -std=c++20 -fprebuilt-module-path=.

%.pcm: %.c++m
	$(CXX) $(CXXFLAGS) --precompile -c -o $@ $<

%.o: %.pcm
	$(CXX) $(CXXFLAGS) -c -o $@ $<

%.o: %.c++
	$(CXX) $(CXXFLAGS) -c -o $@ $<

test.pcm: test-with_lambdas.pcm

main.o: test.pcm

main: main.o test.o test-with_lambdas.o
	$(CXX) $(CXXFLAGS) -o $@ $^

.PHONY: all
all: main

.PHONY: clean
clean:
	rm -f *.o *.pcm main
