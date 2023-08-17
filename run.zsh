#!/bin/zsh

CPO_CMD=(
  /opt/homebrew/opt/perl/bin/chordpro
  --config=chordpro.prp
  --diagrams=none
)

# cpo_transpose_one $1=ID $2=KEY $3=SEMITONE
cpo_transpose_one() {
  ${CPO_CMD[@]} -x $3 -o $1-$2.chordpro.pdf $1.cho
}

cpo_transpose_all() {
  cpo_transpose_one $1 Fi  '+6' # 🔼 SHARP +7
  cpo_transpose_one $1 B_ '+11' # 🔼 SHARP +7
  cpo_transpose_one $1 E_  '+4' # 🔼 SHARP +7
  cpo_transpose_one $1 A_  '+9' # 🔼 SHARP +7
  cpo_transpose_one $1 D_  '+2' # 🔼 SHARP +7
  cpo_transpose_one $1 G_  '+7' # 🔼 SHARP +7
  cpo_transpose_one $1 C_   '0'
  cpo_transpose_one $1 F_  '-7' # 🔽 FLAT -7
  cpo_transpose_one $1 Bb  '-2' # 🔽 FLAT -7
  cpo_transpose_one $1 Eb  '-9' # 🔽 FLAT -7
  cpo_transpose_one $1 Ab  '-4' # 🔽 FLAT -7
  cpo_transpose_one $1 Db '-11' # 🔽 FLAT -7
  cpo_transpose_one $1 Gb  '-6' # 🔽 FLAT -7
}

cpo_transpose_all 715720012
