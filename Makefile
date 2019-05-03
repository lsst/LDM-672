#for dependency you want all tex files  but for acronyms you do not want to include the acronyms file itself.
tex=$(filter-out $(wildcard *aglossary.tex) , $(wildcard *.tex))  

DOC= LDM-672
SRC= $(DOC).tex



OBJ=$(SRC:.tex=.pdf)

#Default when you type make
all: $(OBJ)

$(OBJ): $(tex) aglossary.tex
	latexmk -bibtex -xelatex -f $(SRC)
	makeglossaries $(DOC)        
	xelatex $(SRC)

	

#The generateAcronyms.py  script is in lsst-texmf/bin - put that in the path
aglossary.tex :$(tex) myacronyms.txt
	generateAcronyms.py -g   $(tex)
	generateAcronyms.py -g -u   $(tex) aglossary.tex

clean :
	latexmk -c
	rm *.pdf *.nav *.bbl *.xdv *.snm



