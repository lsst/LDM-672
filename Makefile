#for dependency you want all tex files  but for acronyms you do not want to include the acronyms file itself.
tex=$(filter-out $(wildcard *aglossary.tex) , $(wildcard *.tex))  

DOC= LDM-672
SRC= $(DOC).tex

export TEXMFHOME = lsst-texmf/texmf

OBJ=$(SRC:.tex=.pdf)

#Default when you type make
all: $(OBJ)

$(OBJ): $(tex) aglossary.tex
	xelatex $(DOC)
	makeglossaries $(DOC)
	bibtex $(DOC)
	xelatex $(DOC)
	makeglossaries $(DOC)
	bibtex $(DOC)
	xelatex $(DOC)
	xelatex $(DOC)

aglossary.tex :$(tex) myacronyms.txt
	$(TEXMFHOME)/../bin/generateAcronyms.py -g   $(tex)
	$(TEXMFHOME)/../bin/generateAcronyms.py -g -u   $(tex) aglossary.tex

clean :
	latexmk -c
	rm *.pdf *.nav *.bbl *.xdv *.snm



