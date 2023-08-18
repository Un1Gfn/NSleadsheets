#!/bin/zsh

# cpo_transpose_one_key $1=ID $2=KEY $3=SEMITONE
cpo_transpose_one_key() {

  # command line options
  # https://metacpan.org/pod/App::Music::ChordPro
  # https://www.chordpro.org/chordpro/using-chordpro/
  
  CPO_CMD=(
    /opt/homebrew/opt/perl/bin/chordpro
    --config=conf.prp
    # --config=$1.prp
    --diagrams=none
    -x $3
    # -o $1-$2.chordpro.pdf
    -o test.chordpro.pdf
    $1.cho
  )
  if [ -e $1.prp ]; then
    CPO_CMD+=(--config=$1.prp)
  fi
  ${CPO_CMD[@]}
}

# https://en.wikipedia.org/wiki/Circle_of_fifths
# cpo_transpose_all $1=ID
cpo_transpose_all_keys() {
  cpo_transpose_one_key $1 Fi  '+6' # 🔼 SHARP +7
  cpo_transpose_one_key $1 B_ '+11' # 🔼 SHARP +7
  cpo_transpose_one_key $1 E_  '+4' # 🔼 SHARP +7
  cpo_transpose_one_key $1 A_  '+9' # 🔼 SHARP +7
  cpo_transpose_one_key $1 D_  '+2' # 🔼 SHARP +7
  cpo_transpose_one_key $1 G_  '+7' # 🔼 SHARP +7
  cpo_transpose_one_key $1 C_   '0'
  cpo_transpose_one_key $1 F_  '-7' # 🔽 FLAT -7
  cpo_transpose_one_key $1 Bb  '-2' # 🔽 FLAT -7
  cpo_transpose_one_key $1 Eb  '-9' # 🔽 FLAT -7
  cpo_transpose_one_key $1 Ab  '-4' # 🔽 FLAT -7
  cpo_transpose_one_key $1 Db '-11' # 🔽 FLAT -7
  cpo_transpose_one_key $1 Gb  '-6' # 🔽 FLAT -7
}

cpo_ckey_one_song() {
  cpo_transpose_one_key $1 C_ '0'
}

cpo_ckey_all_songs() {
  for i in *.cho; do
    cpo_ckey_one_song ${i:r}
  done
}

# cpo_ckey_all_songs

# cpo_ckey_one_song 715720012
# cpo_ckey_one_song 1443158231
# cpo_ckey_one_song 1440837672
cpo_ckey_one_song 1175720998
