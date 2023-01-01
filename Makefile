.DEFAULT_GOAL = all
OS = $(shell uname -s)

ifeq ($(OS),Linux)
CXX = /usr/lib/llvm-15/bin/clang++ -pthread
CXXFLAGS = -I/usr/lib/llvm-15/include/c++/v1
LDFLAGS = -lc++ -L/usr/lib/llvm-15/lib/c++
endif

ifeq ($(OS),Darwin)
CXX = /opt/homebrew/opt/llvm/bin/clang++
CXXFLAGS =-I/opt/homebrew/opt/llvm/include/c++/v1
LDFLAGS += -L/opt/homebrew/opt/llvm/lib/c++
endif

CXXFLAGS += -std=c++20 -stdlib=libc++
CXXFLAGS += -fprebuilt-module-path=$(objectdir)
CXXFLAGS += -Wall -Wextra
CXXFLAGS += -I$(sourcedir)
LDFLAGS += -fuse-ld=lld

sourcedir = .
objectdir = .
binarydir = bin
dependencies = $(objectdir)/Makefile.deps

programs = main

targets = $(programs:%=$(binarydir)/%)
sources = $(filter-out $(programs:%=$(sourcedir)/%.c++), $(wildcard $(sourcedir)/*.c++))
modules = $(wildcard $(sourcedir)/*.c++m)
objects = $(modules:$(sourcedir)%.c++m=$(objectdir)%.o) $(sources:$(sourcedir)%.c++=$(objectdir)%.o)

$(objectdir)/%.pcm: $(sourcedir)/%.c++m
	@mkdir -p $(@D)
	$(CXX) $(CXXFLAGS) $< --precompile -c -o $@

$(objectdir)/%.o: $(objectdir)/%.pcm
	@mkdir -p $(@D)
	$(CXX) $< -c -o $@

$(objectdir)/%.test.o: $(sourcedir)/%.test.c++
	@mkdir -p $(@D)
	$(CXX) $(CXXFLAGS) $< -c -o $@

$(objectdir)/%.o: $(sourcedir)/%.c++
	@mkdir -p $(@D)
	$(CXX) $(CXXFLAGS) $< -c -o $@

$(binarydir)/%: $(sourcedir)/%.c++ $(objects)
	@mkdir -p $(@D)
	$(CXX) $(CXXFLAGS) $(LDFLAGS) $^ -o $@

$(dependencies): $(sources) $(modules)
	@mkdir -p $(@D)
#c++m module wrapping headers etc.
	grep -HEL '\export module;' $(sourcedir)/*.c++m | sed -r 's/^(.*\/)([a-z_0-9\-]+).c\+\+m/$(objectdir)\/\2.o: $(objectdir)\/\2.pcm/' > $(dependencies)
#c++m module interface unit
	grep -HE '\s*import\s+([a-z_0-9]+)' $(sourcedir)/*.c++m | sed -r 's/^(.*\/)([a-z_0-9\-]+).c\+\+m:import ([a-z_0-9]+);/$(objectdir)\/\2.pcm: $(objectdir)\/\3.pcm/' >> $(dependencies)
#c++m module partition unit
	grep -HE '\s*import\s+:([a-z_0-9]+)' $(sourcedir)/*.c++m | sed -r 's/^(.*\/)([a-z_0-9]+)(\-*)([a-z_0-9]*).c\+\+m:(.*)import :([a-z_0-9]+);/$(objectdir)\/\2\3\4.pcm: $(objectdir)\/\2\-\6.pcm/' >> $(dependencies)
#c++m module implementation unit
	grep -HE '\s*module\s+([a-z_0-9]+)' $(sourcedir)/*.c++ | sed -r 's/^(.*\/)([a-z_0-9\-\.]+).c\+\+:module ([a-z_0-9]+);/$(objectdir)\/\2.o: $(objectdir)\/\3.pcm/' >> $(dependencies)
#c++ source code
	grep -HE '\s*import\s+([a-z_0-9]+)' $(sourcedir)/*.c++ | sed -r 's/^(.*\/)([a-z_0-9\-\.]+).c\+\+:import ([a-z_0-9]+);/$(objectdir)\/\2.o: $(objectdir)\/\3.pcm/' >> $(dependencies)

-include $(dependencies)

.PHONY: all
all: $(dependencies) $(targets)

.PHONY: clean
clean:
	rm -rf $(objectdir)/*.o $(objectdir)/*.pcm $(objectdir)/*.deps $(targets)

.PHONY: dump
dump:
	$(foreach v, $(sort $(.VARIABLES)), $(if $(filter file,$(origin $(v))), $(info $(v)=$($(v)))))
	@echo ''
