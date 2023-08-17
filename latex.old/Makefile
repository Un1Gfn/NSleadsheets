MAKEFLAGS:=$(MAKEFLAGS) -j1

default: pdf

clean:
	@echo
	grm -fv *.aux *.log *.toc *.out index.pdf

pdf:
	@clear
	@printf "\e[3J"
	@tput reset
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

share:
	T=/tmp/index_gdate%s_$$(gdate +%s).pdf; \
	gcp -v index.pdf $$T; \
	gcp -v $$T '/Users/darren/Library/Mobile Documents/com~apple~CloudDocs/euw9o3/'; \
	sudo zsh /usr/local/bin/tgbot.zsh $$T; \
	grm -v $$T
