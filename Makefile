
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

ZIP:=/opt/homebrew/opt/zip/bin/zip
CHORDII:=/opt/homebrew/bin/chordii
CHORDPRO:=/opt/homebrew/opt/perl/bin/chordpro
PERL:=/opt/homebrew/opt/perl/bin/perl
MAKEFLAGS:=-j1

# if set to 1, generate favorite transpose only
MK_CPO_SUPPRESS_EVERYTHING:=0

# if set to 1, disable incremental builds
MK_CPO_NO_INCREMENTAL:=1

default:
	$(MAKE) clean
	$(MAKE) pdf
	$(MAKE) merge
	$(MAKE) zip.sheets
	$(MAKE) zip.audio

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
	@grm -f \
		NSleadsheets-Audio.zip \
		NSleadsheets-Sheets.zip \
		tmpd.sheets/everything/*.pdf \
		tmpd.sheets/*.pdf \
		tmpd.audio/*.m4a
	@echo clean complete
	@gfind tmpd.* | gsort

# a2crd:
# 	@echo
# 	@$(CHORDPRO) --a2crd tmp.txt
# 	@echo

# loop:
# 	while true; do clear; printf \\e\[3J; $(MAKE) pdf; done

# entr:
# 	gls -A1 *.cho *.prp | entr sh -c 'clear; printf \\e\[3J; $(MAKE) pdf'

pdf:
	@echo
	@env CPO_OUT=tmpd.sheets CPO_SUPPRESS_EVERYTHING=$(MK_CPO_SUPPRESS_EVERYTHING) CPO_NO_INCREMENTAL=$(MK_CPO_NO_INCREMENTAL) ./script_chordpro.zsh
	@echo

view:
	# cd tmpd.sheets/; for i in *.pdf; do open "$$i"; sleep 0.1618; done
	cd tmpd.sheets/; open merge*

merge:
	cd tmpd.sheets/; qpdf --empty --pages ??-*.pdf -- merge.pdf
	cd tmpd.sheets/; pdfjam --paper a3paper --landscape --nup 2x1 merge.pdf -o merge-pdfjam.pdf

zip.sheets:
	$(ZIP)    -X -r NSleadsheets-Sheets.zip tmpd.sheets/

zip.audio:
	./script_mksymlnk.zsh
	$(ZIP) -0 -X -r NSleadsheets-Audio.zip tmpd.audio/

# NSleadsheets-Audio.zip is static
# NSleadsheets-Audio.zip should be shared manually
# NSleadsheets-Sheets.zip should be shared by this recipe
share:
	T=/tmp/NSleadsheets-Sheets-$$(gdate +%s).zip; \
	gcp -v NSleadsheets-Sheets.zip $$T; \
	gcp -v $$T '/Users/darren/Library/Mobile Documents/com~apple~CloudDocs/euw9o3/'; \
	sudo zsh /usr/local/bin/tgbot.zsh $$T; \
	grm -v $$T

list:
	ggrep --color=auto -nri -e subtitle -e title *.cho

status:
	@echo
	@gtr -s ' ' <status.txt | gcolumn -L -s\| -o\| -t | gtail -n+1
	@echo
