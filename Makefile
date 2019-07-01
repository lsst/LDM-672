#for dependency you want all tex files  but for acronyms you do not want to include the acronyms file itself.
tex=$(filter-out $(wildcard *aglossary.tex) , $(wildcard *.tex))  

DOC= LDM-672
SRC= $(DOC).tex

TEXMFHOME ?= lsst-texmf/texmf

# Version information extracted from git.
GITVERSION := $(shell git log -1 --date=short --pretty=%h)
GITDATE := $(shell git log -1 --date=short --pretty=%ad)
GITSTATUS := $(shell git status --porcelain)
ifneq "$(GITSTATUS)" ""
        GITDIRTY = -dirty
endif

OBJ=$(SRC:.tex=.pdf)

#Default when you type make
all: $(OBJ)

$(OBJ): $(tex) meta.tex aglossary.tex
	xelatex $(DOC)
	makeglossaries $(DOC)
	bibtex $(DOC)
	xelatex $(DOC)
	makeglossaries $(DOC)
	bibtex $(DOC)
	xelatex $(DOC)
	xelatex $(DOC)

.FORCE:

aglossary.tex :$(tex) myacronyms.txt
	$(TEXMFHOME)/../bin/generateAcronyms.py -g   $(tex)
	$(TEXMFHOME)/../bin/generateAcronyms.py -g $(tex) aglossary.tex

clean :
	latexmk -c
	rm *.pdf *.nav *.bbl *.xdv *.snm


meta.tex: Makefile .FORCE
	rm -f $@
	touch $@
	echo '% GENERATED FILE -- edit this in the Makefile' >>$@
	/bin/echo '\newcommand{\lsstDocType}{$(DOCTYPE)}' >>$@
	/bin/echo '\newcommand{\lsstDocNum}{$(DOCNUMBER)}' >>$@
	/bin/echo '\newcommand{\vcsrevision}{$(GITVERSION)$(GITDIRTY)}' >>$@
	/bin/echo '\newcommand{\vcsdate}{$(GITDATE)}' >>$@

myacronyms.txt:
	touch myacronyms.txt
