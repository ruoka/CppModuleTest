/usr/lib/llvm-15/bin/clang++ -std=c++20 -fprebuilt-module-path=. --precompile -c module_with_lambda.c++m -o test.pcm
/usr/lib/llvm-15/bin/clang++ -std=c++20 -fprebuilt-module-path=. main.c++ test.pcm -o main
