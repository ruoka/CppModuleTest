/opt/bin/clang++ -std=c++20 -fprebuilt-module-path=. -Xclang -emit-module-interface -c module.cpp -o test.pcm
/opt/bin/clang++ -std=c++20 -fprebuilt-module-path=. main.cpp test.pcm -o main
