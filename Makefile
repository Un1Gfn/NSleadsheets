
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

ifeq ($(shell uname -s),Darwin)
  $(info loading homebrew compat $$PATH ...)
  include /usr/local/share/make/compat.mk
endif

MAKEFLAGS:=-j1

# if set to 1, generate favorite transpose only
MK_CPO_SUPPRESS_EVERYTHING:=0

# if set to 1, disable incremental builds
MK_CPO_NO_INCREMENTAL:=1

default:
	$(MAKE) clean
	$(MAKE) pdf
	# $(MAKE) merge
	# $(MAKE) zip.sheets
	# $(MAKE) zip.audio

info:
	@echo
	chordii -V
	@echo
	perl -v
	@echo
	chordpro --version
	@echo
	chordpro --help
	@echo

clean:
	@rm -fv \
		NSleadsheets-Audio.zip \
		NSleadsheets-Sheets.zip
	@rm -f \
		tmpd.sheets/everything/*.pdf \
		tmpd.sheets/*.pdf \
		tmpd.audio/*.m4a \
		tmpd.audio/*.flac
	@echo clean complete
	@find tmpd.* | gsort

# @chordpro --a2crd tmp.in >tmp.out
a2crd:
	@echo
	@cat >/tmp/h3yof4.txt; clear; echo; echo; chordpro --a2crd /tmp/h3yof4.txt; echo; rm -f /tmp/h3yof4.txt
	@echo

# loop:
# 	while true; do clear; printf \\e\[3J; $(MAKE) pdf; done

entr:
	ls -A1 *.cho *.prp | entr sh -c ':; printf \\e\[3J; $(MAKE) clean pdf'

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
	zip -9 -X -r NSleadsheets-Sheets.zip tmpd.sheets/
	# find tmpd.sheets/ | sort | zip -o -9 -X -r -@ NSleadsheets-Sheets.zip

zip.audio:
	./script_mksymlnk.zsh
	zip -0 -X -r NSleadsheets-Audio.zip tmpd.audio/

# NSleadsheets-Audio.zip is static
# NSleadsheets-Audio.zip should be shared manually
# NSleadsheets-Sheets.zip should be shared by this recipe
share:
	T=/tmp/NSleadsheets-Sheets-$$(gdate +%s).zip; \
	cp -v NSleadsheets-Sheets.zip $$T; \
	cp -v $$T '/Users/darren/Library/Mobile Documents/com~apple~CloudDocs/euw9o3/'; \
	sudo zsh /usr/local/bin/tgbot.zsh $$T; \
	rm -v $$T

adb:
	@echo
	adb devices
	adb shell uname -a
	@echo
	@sleep 1
	-adb push NSleadsheets-Sheets.zip /sdcard/Download/Telegram/NSleadsheets-Sheets-$(shell gdate +%s).zip
	@echo
	-adb push NSleadsheets-Audio.zip  /sdcard/Download/Telegram/NSleadsheets-Audio-$(shell gdate +%s).zip

list:
	ggrep --color=auto -nri -e subtitle -e title *.cho

status:
	@echo
	@gtr -s ' ' <status.txt | gcolumn -L -s\| -o\| -t | gtail -n+1
	@echo
