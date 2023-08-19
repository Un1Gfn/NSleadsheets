
# chordii
# https://sourceforge.net/projects/chordii/
# https://www.vromans.org/johan/projects/Chordii/

# chordpro.install
# https://www.chordpro.org/
# https://github.com/ChordPro/chordpro/
# https://metacpan.org/dist/App-Music-ChordPro

# chordpro.install.wx.err
# brew install wxWidgets
# add 'adv'=>... to the following file before 
# /opt/homebrew/Cellar/perl/5.36.1/lib/perl5/site_perl/5.36/darwin-thread-multi-2level/Alien/wxWidgets/Config/mac_3_2_2_uni_nc_0.pm
# # https://www.nntp.perl.org/group/perl.wxperl.users/2012/06/msg8477.html
# cpan -i Alien:Wx
# lots of errors

# chordpro.usage
# https://www.chordpro.org/chordpro/chordpro-install-on-macos/#personal-configuration
# https://metacpan.org/dist/App-Music-ChordPro/view/lib/ChordPro/A2Crd.pm
# https://metacpan.org/pod/App::Music::ChordPro

# convert
# https://ultimate.ftes.de/
# https://github.com/ftes/ultimate-to-chordpro

# collections
# https://github.com/mcruncher/worshipsongs-db-dev
# # https://github.com/mcruncher/worshipsongs-android
# https://github.com/mattgraham/worship
# https://github.com/pathawks/Christmas-Songs/

# 2023-08-17
# https://www.jrchord.com/worthy-is-the-lamb-hillsong

CHORDII:=/opt/homebrew/bin/chordii
CHORDPRO:=/opt/homebrew/opt/perl/bin/chordpro
PERL:=/opt/homebrew/opt/perl/bin/perl
MAKEFLAGS:=-j1

default:
	$(MAKE) clean
	sleep 1
	$(MAKE) entr
	# $(MAKE) pdf
	# $(MAKE) zip
	# $(MAKE) view

info:
	@echo
	$(CHORDII) -V
	@echo
	$(PERL) -v
	@echo
	$(CHORDPRO) --version
	@echo
	$(CHORDPRO) --help
	@echo

clean:
	grm -fv out/everything/*.pdf out/*.pdf

a2crd:
	@echo
	@$(CHORDPRO) --a2crd tmp.txt
	@echo

loop:
	while true; do clear; printf \\e\[3J; $(MAKE) pdf; done

entr:
	gls -A1 *.cho *.prp | entr sh -c 'clear; printf \\e\[3J; $(MAKE) pdf'

pdf:
	@echo
	@./run.zsh
	@echo

view:
	open out/*.pdf

# zip:
# 	grm -fv chordpro.zip
# 	zip -0 -X chordpro.zip *.chordpro.pdf

share:
	T=/tmp/chordpro-$$(gdate +%s).zip; \
	gcp -v chordpro.zip $$T; \
	gcp -v $$T '/Users/darren/Library/Mobile Documents/com~apple~CloudDocs/euw9o3/'; \
	sudo zsh /usr/local/bin/tgbot.zsh $$T; \
	grm -v $$T

list:
	ggrep --color=auto -nri -e subtitle -e title *.cho

status:
	@echo
	@gtr -s ' ' <status.txt | gcolumn -L -s\| -o\| -t | gtail -n+1
	@echo
