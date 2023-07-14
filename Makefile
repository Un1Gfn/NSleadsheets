MAKEFLAGS:=$(MAKEFLAGS) -j1

default: pdf

clean:
	@echo
	grm -fv *.aux *.log *.toc *.out index.pdf

pdf:
	@echo
	xelatex -halt-on-error -interaction=nonstopmode index.tex

# TOC requires incremental build
#	gls -A1 *.tex | entr sh -c 'clear; printf \\e\[3J $(MAKE) clean; $(MAKE) pdf'
entr:
	gls -A1 *.tex | entr $(MAKE) pdf

view:
	open *.pdf

adb:
	adb push index.pdf /sdcard/Download/WeChat/index_gdate%s_$(shell gdate +%s).pdf
