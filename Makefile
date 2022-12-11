all:
	/usr/lib/llvm-15/bin/clang++ -std=c++20 -fprebuilt-module-path=. --precompile -c test-module_with_lambdas.c++m -o test-module_with_lambdas.pcm
	/usr/lib/llvm-15/bin/clang++ -std=c++20 -fprebuilt-module-path=. --precompile -c test.c++m -o test.pcm
	/usr/lib/llvm-15/bin/clang++ -std=c++20 -fprebuilt-module-path=. main.c++ test.pcm test-module_with_lambdas.pcm -o main
