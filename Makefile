MAKEFLAGS:=$(MAKEFLAGS) -j1

default: pdf

clean:
	@echo
	grm -fv *.aux *.log index.pdf

pdf:
	@echo
	xelatex -halt-on-error -interaction=nonstopmode index.tex

entr:
	gls -A1 *.tex | entr sh -c 'clear; printf \\e\[3J $(MAKE) clean; $(MAKE) pdf'

view:
	open *.pdf
