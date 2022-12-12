.DEFAULT_GOAL := all

CXX := /usr/lib/llvm-15/bin/clang++
CXXFLAGS := -std=c++20 -fprebuilt-module-path=.

program := main
sources := $(wildcard *.c++) $(wildcard *.c++m)
objects := $(sources:%.c++=%.o)
objects := $(objects:%.c++m=%.o)

%.pcm: %.c++m
	$(CXX) $(CXXFLAGS) $< --precompile -c -o $@

%.o: %.pcm
	$(CXX) $(CXXFLAGS) $< -c -o $@

%.test.o: %.test.c++
	$(CXX) $(CXXFLAGS) $< -fmodule-file=$*.pcm -c -o $@

%.o: %.c++
	$(CXX) $(CXXFLAGS) $< -c -o $@

$(program): $(objects)
	$(CXX) $(CXXFLAGS) $^ -o $@

$(program).d: $(sources)
	rm -f $(program).d
#c++m module interface unit
	grep -H -E '\s*import\s*([a-z_0-9]+)' *.c++m | sed -E 's/(^[a-z_0-9]+)\.c\+\+m:.*import\s*([a-z_0-9]+);/\1.pcm: \2.pcm/' > $(program).d
#c++m module partition unit
	grep -H -E '\s*import\s*:([a-z_0-9]+)' *.c++m | sed -E 's/(^[a-z_0-9]+)\.c\+\+m:.*import\s*:([a-z_0-9]+);/\1.pcm: \1-\2.pcm/' >> $(program).d
#c++ module implementation unit
	grep -H -E '\s*module\s*([a-z_0-9]+)' *.test.c++ | sed -E 's/(^[a-z_0-9\-]+)\.test\.c\+\+:\s*module\s*([a-z_0-9]+);/\1.test.o: \2.pcm/' >> $(program).d
#c++ module user
	grep -H -E '\s*import\s*([a-z_0-9]+)' *.c++ | sed -E 's/(^[a-z_0-9]+)\.c\+\+:\s*import\s*([a-z_0-9]+);/\1.o: \2.pcm/' >> $(program).d

-include $(program).d

.PHONY: all
all: $(program).d $(program)

.PHONY: clean
clean:
	rm -f *.o *.pcm $(program).d $(program)

.PHONY: info
info:
	@echo $(sources)
	@echo $(objects)
