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
	$(MAKE) clean
	gls -A1 *.tex | entr $(MAKE) pdf

view:
	open *.pdf

adb:
	adb push index.pdf /sdcard/Download/WeChat/index_gdate%s_$(shell gdate +%s).pdf

tgbot:
	T=/tmp/index_gdate%s_$$(gdate +%s).pdf; \
	gcp -v index.pdf $$T; \
	sudo zsh ./tgbot.zsh $$T; \
	grm -v $$T

icloud:
	gcp -vi index.pdf '/Users/darren/Library/Mobile Documents/com~apple~CloudDocs/euw9o3/index_gdate%s_$(shell gdate +%s).pdf'
