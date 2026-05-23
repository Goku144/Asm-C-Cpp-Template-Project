# MIT License
#
# Copyright (c) 2026 Orion
#

prog := app

CXX     := g++
CXXFlag := -O3
CXXInc  := -Iinterface -Iapp/inc
CXXLib  :=

ASM     := nasm
ASMFlag := -f elf64 -F dwarf
ASMInc  := -Iasm/inc/
ASMLib  :=

appSrc  := $(shell find app/src/ -name "*.cpp")
appObj  := $(patsubst app/src/%.cpp,app/bin/%.o,$(appSrc))
appPair := $(join $(patsubst %,%:,$(appObj)),$(appSrc))
appRule := $(CXX) $(CXXFlag) $(CXXInc) -c $$^ $(CXXLib) -o $$@

asmSrc  := $(shell find asm/src/ -name "*.asm")
asmObj  := $(patsubst asm/src/%.asm,asm/bin/%.o,$(asmSrc))
asmPair := $(join $(patsubst %,%:,$(asmObj)),$(asmSrc))
asmRule := $(ASM) $(ASMFlag) $(ASMInc) $$^ $(ASMLib) -o $$@

classSrc  := $(shell find class/ -name "*.cpp")
classObj  := $(join $(dir $(patsubst class/%.cpp,lib/%.cpp,$(classSrc))), $(patsubst %.cpp,lib%.so,$(notdir $(classSrc))))
classPair := $(join $(patsubst %,%:,$(classObj)),$(classSrc))
classRule := $(CXX) $(CXXFlag) $(CXXInc) -fPIC -shared $$^ $(CXXLib) -o $$@

ldFlag := $(foreach Dir, $(dir $(patsubst class/%.cpp,lib/%.cpp,$(classSrc))),-L$(Dir) -Wl,-rpath,$(Dir))
ldLib  := $(foreach name, $(notdir $(classSrc)),-l$(basename $(name)))

progSrc  := $(appObj) $(asmObj) $(classObj)
progObj  := app/build/$(prog)
progPair := $(join $(patsubst %,%:,$(progObj)),$(progSrc))
progRule := $(CXX) $(CXXFlag) $$^ $(ldFlag) $(ldLib) $(CXXLib) -o $$@

define objRule
$(1)
	@mkdir -p $$(dir $$@)
	$(2)
endef

define objEval
$(eval $(call objRule,$(1),$($(2)Rule)))
endef

define objLoop
$(foreach pair,$($(1)Pair),$(call objEval,$(pair),$(1)))
endef

all: lib asm app prog

prog: $(progObj)
	@sudo install -m 755 app/build/$(prog) /usr/local/bin/$(prog)

$(call objEval,$(progPair),prog)

app: $(appObj)

$(call objLoop,app)

asm: $(asmObj)

$(call objLoop,asm)

lib: $(classObj)

$(call objLoop,class)

clean:
	sudo rm -rf app/build app/bin asm/bin lib/* /usr/local/bin/$(prog)

.PHONY: all lib app prog clean
