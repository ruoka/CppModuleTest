.DEFAULT_GOAL := all

CXX := /usr/lib/llvm-15/bin/clang++
CXXFLAGS := -std=c++20 -fprebuilt-module-path=.

program := main
sources := $(wildcard *.c++) $(wildcard *.c++m)
objects := $(sources:%.c++=%.o)
objects := $(objects:%.c++m=%.o)

%.pcm: %.c++m
	$(CXX) $(CXXFLAGS) --precompile -c -o $@ $<

%.o: %.pcm
	$(CXX) $(CXXFLAGS) -c -o $@ $<

%.o: %.c++
	$(CXX) $(CXXFLAGS) -c -o $@ $<

main: $(objects)
	$(CXX) $(CXXFLAGS) -o $@ $^

$(program).d:
	rm -f $(program).d
#c++
	grep -H -E '\s*import\s*([a-z_0-9]+)' *.c++ | sed -E 's/(^[a-z_0-9]+)\.c\+\+:\s*import\s*([a-z_0-9]+);/\1.o: \2.pcm/' > $(program).d
#c++ partition
	grep -H -E '\s*import\s*:([a-z_0-9]+)' *.c++ | sed -E 's/(^[a-z_0-9]+)\.c\+\+:\s*import\s*([a-z_0-9]+);/\1.o: \1-\2.pcm/' >> $(program).d
#c++m
	grep -H -E '\s*import\s*([a-z_0-9]+)' *.c++m | sed -E 's/(^[a-z_0-9]+)\.c\+\+m:.*import\s*([a-z_0-9]+);/\1.pcm: \2.pcm/' >> $(program).d
#c++m partition
	grep -H -E '\s*import\s*:([a-z_0-9]+)' *.c++m | sed -E 's/(^[a-z_0-9]+)\.c\+\+m:.*import\s*:([a-z_0-9]+);/\1.pcm: \1-\2.pcm/' >> $(program).d

-include $(program).d

.PHONY: clean
clean:
	rm -f *.o *.pcm $(program).d $(program)

.PHONY: all
all: $(program).d $(program)

.PHONY: info
info:
	@echo $(sources)
	@echo $(objects)
