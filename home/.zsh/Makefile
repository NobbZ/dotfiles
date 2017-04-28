SHELL = zsh
ZCOMPILE = zcompile -Uz

FUNS = $(shell find funs -type f -not -name '*.zwc')
FUNS_ZWC = $(FUNS:%=%.zwc)

COMPILED_SCRIPTS = $(FUNS_ZWC)

all: $(COMPILED_SCRIPTS)

clean: $(COMPILED_SCRIPTS:%=%_clean)

## ========================================
## Auxiliary targets
## ========================================

%.zwc: %
	$(ZCOMPILE) $<

## ========================================
## Cleaning targets
## ========================================

%_clean:
	rm -fv $*