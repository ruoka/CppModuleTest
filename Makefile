.DEFAULT_GOAL := all

.PHONY: pcm
pcm:
	/usr/lib/llvm-15/bin/clang++ -std=c++20 -fprebuilt-module-path=. --precompile -c test-with_lambdas.c++m -o test-with_lambdas.pcm
	/usr/lib/llvm-15/bin/clang++ -std=c++20 -fprebuilt-module-path=. --precompile -c test.c++m -o test.pcm

.PHONY: obj
obj: pcm
	/usr/lib/llvm-15/bin/clang++ -std=c++20 -fprebuilt-module-path=. -c test-with_lambdas.pcm -o test-with_lambdas.o
	/usr/lib/llvm-15/bin/clang++ -std=c++20 -fprebuilt-module-path=. -c test.pcm -o test.o

.PHONY: exe
exe: obj
	/usr/lib/llvm-15/bin/clang++ -std=c++20 -fprebuilt-module-path=. main.c++ test.o test-with_lambdas.o -o main

.PHONY: all
all: exe
