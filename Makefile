all:
	/usr/lib/llvm-15/bin/clang++ -std=c++20 -fprebuilt-module-path=. --precompile -c test-with_lambdas.c++m -o test-with_lambdas.pcm
	/usr/lib/llvm-15/bin/clang++ -std=c++20 -fprebuilt-module-path=. --precompile -c test.c++m -o test.pcm
	/usr/lib/llvm-15/bin/clang++ -std=c++20 -fprebuilt-module-path=. main.c++ test.pcm test-with_lambdas.pcm -o main
