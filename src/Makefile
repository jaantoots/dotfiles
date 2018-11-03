INSTALL := install
prefix := $(HOME)
bindir := $(prefix)/bin

CFLAGS := -O2 -Wall
BIN := lz4jsoncat
ALL := .gitignore $(BIN)

.PHONY: all
all: $(ALL)

%: %.c

lz4jsoncat: LDLIBS := $(shell pkg-config --cflags --libs liblz4)

.gitignore:
	echo "# Automatically generated gitignore by make" > .gitignore
	for target in $(ALL); do echo $$target >> .gitignore; done

.PHONY: install
install: all
	$(INSTALL) -t $(bindir) $(BIN)
	$(INSTALL) -m 644 -t $(bindir) .gitignore

.PHONY: clean
clean:
	-rm $(ALL)
