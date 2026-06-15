progName := prog
appName  := app
asmName  := asm
libName  := lib
objBase  := target

CXX     := g++
CXXFlag := -O3
CXXInc  := -Iinterface/src/$(appName)/ -Iinterface/class/
CXXLib  :=

ASM     := nasm
ASMFlag := -f elf64 -F dwarf
ASMInc  := -Iinterface/src/$(asmName)/
ASMLib  :=

appBase := project/src/$(appName)
appSrc  := $(shell find $(appBase)/ -name "*.cpp")
appObj  := $(patsubst $(appBase)/%.cpp,$(objBase)/bin/$(appName)/%.o,$(appSrc))
appPair := $(join $(patsubst %,%:,$(appObj)),$(appSrc))
appRule := $(CXX) $(CXXFlag) $(CXXInc) -c $$^ $(CXXLib) -o $$@

asmBase := project/src/$(asmName)
asmSrc  := $(shell find $(asmBase)/ -name "*.asm")
asmObj  := $(patsubst $(asmBase)/%.asm,$(objBase)/bin/$(asmName)/%.o,$(asmSrc))
asmPair := $(join $(patsubst %,%:,$(asmObj)),$(asmSrc))
asmRule := $(ASM) $(ASMFlag) $(ASMInc) $$^ $(ASMLib) -o $$@

classBase := project/class
classSrc  := $(shell find $(classBase)/ -name "*.cpp")
classObj  := $(join $(dir $(patsubst $(classBase)/%.cpp,$(objBase)/$(libName)/%.cpp,$(classSrc))), $(patsubst %.cpp,lib%.so,$(notdir $(classSrc))))
classPair := $(join $(patsubst %,%:,$(classObj)),$(classSrc))
classRule := $(CXX) $(CXXFlag) $(CXXInc) -fPIC -shared $$^ $(CXXLib) -o $$@

ldFlag := $(foreach Dir, $(dir $(patsubst $(classBase)/%.cpp,$(objBase)/$(libName)/%.cpp,$(classSrc))),-L$(Dir) -Wl,-rpath,$(Dir))
ldLib  := $(foreach name, $(notdir $(classSrc)),-l$(basename $(name)))

progBase := $(objBase)/build
progSrc  := $(appObj) $(asmObj) $(classObj)
progObj  := $(progBase)/$(progName)
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
	@sudo install -m 755 $(progBase)/$(progName) /usr/local/bin/$(progName)

$(call objEval,$(progPair),prog)

app: $(appObj)

$(call objLoop,app)

asm: $(asmObj)

$(call objLoop,asm)

lib: $(classObj)

$(call objLoop,class)

clean:
	sudo rm -rf target /usr/local/bin/$(progName)

.PHONY: all lib app prog clean