// M.cppm
export module M;
export import :interface_part;
import :impl_part;
export void Hello();

// interface_part.cppm
export module M:interface_part;
export void World();

// impl_part.cppm
module;
#include <iostream>
#include <string>
module M:impl_part;
import :interface_part;

std::string W = "World.";
void World() {
  std::cout << W << std::endl;
}

// Impl.cpp
module;
#include <iostream>
module M;
void Hello() {
  std::cout << "Hello ";
}

// User.cpp
import M;
int main() {
  Hello();
  World();
  return 0;
}




# Precompiling the module
$ clang++ -std=c++20 interface_part.cppm --precompile -o M-interface_part.pcm
$ clang++ -std=c++20 impl_part.cppm --precompile -fprebuilt-module-path=. -o M-impl_part.pcm
$ clang++ -std=c++20 M.cppm --precompile -fprebuilt-module-path=. -o M.pcm
$ clang++ -std=c++20 Impl.cpp -fmodule-file=M.pcm -c -o Impl.o

# Compiling the user
$ clang++ -std=c++20 User.cpp -fprebuilt-module-path=. -c -o User.o

# Compiling the module and linking it together
$ clang++ -std=c++20 M-interface_part.pcm -c -o M-interface_part.o
$ clang++ -std=c++20 M-impl_part.pcm -c -o M-impl_part.o
$ clang++ -std=c++20 M.pcm -c -o M.o
$ clang++ User.o M-interface_part.o  M-impl_part.o M.o Impl.o -o a.out