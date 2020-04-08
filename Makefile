CWD    = $(CURDIR)
MODULE = $(notdir $(CWD))

NOW = $(shell date +%d%m%y)
REL = $(shell git rev-parse --short=4 HEAD)

NIM = $(HOME)/.nimble/bin/nim



.PHONY: all
all: ./$(MODULE) $(MODULE).ini
	./$^

./$(MODULE): $(MODULE).nim Makefile
	$(NIM) c $< && size $@



.PHONY: merge shadow release zip

MERGE  = Makefile README.md .gitignore .vscode
MERGE += $(MODULE).*

master:
	git checkout master
	git checkout shadow -- $(MERGE)

shadow:
	git checkout shadow

release:
	git tag $(NOW)-$(REL)
	git push -v && git push -v --tags
	git checkout shadow

zip:
	git archive --format zip --output $(MODULE)_src_$(NOW)_$(REL).zip HEAD
