#!/bin/zsh -e

# https://zsh.sourceforge.io/Doc/Release/Parameters.html#Array-Parameters

# cpo_append $1=ASID $2=MPTKEY $3=TITLE
cpo_reldb_append() {
  CPO_RELDB_KEYS+=($1)
  CPO_RELDB_FIELD_MPTKEY+=([$1]=$2)
  CPO_RELDB_FIELD_TITLE+=([$1]=$3)
}

cpo_reldb_dump() {
  declare -p1 CPO_RELDB_KEYS
  declare -p1 CPO_RELDB_FIELD_MPTKEY
  declare -p1 CPO_RELDB_FIELD_TITLE
}

cpo_db_init() {

  declare -g -a CPO_RELDB_KEYS
  declare -g -A CPO_RELDB_FIELD_MPTKEY
  declare -g -A CPO_RELDB_FIELD_TITLE

  cpo_reldb_append 1566041338 "C_" "House Of The Lord"
  cpo_reldb_append 993160497  "C_" "Trading My Sorrows"
  cpo_reldb_append 655662082  "C_" "You Are Good"

  cpo_reldb_append 1175720998 "C_" "Way Maker"
  cpo_reldb_append 715720012  "C_" "Worthy Is the Lamb"
  cpo_reldb_append 1019249219 "C_" "There Is None Like You"

  cpo_reldb_append 1443158231 "C_" "Amazing Grace My Chains Are Gone"
  cpo_reldb_append 1440837672 "C_" "Good Good Father"
  cpo_reldb_append 1502316160 "C_" "The Blessing"

  cpo_reldb_append 1192789624 "C_" "Do It Again"

}

cpo_db_print() {
  echo
  echo ${CPO_RELDB_KEYS[*]}
  echo
  echo ${(k)CPO_RELDB_FIELD_TITLE}
  echo
  echo ${(v)CPO_RELDB_FIELD_TITLE}
  echo
  echo ${(kv)CPO_RELDB_FIELD_TITLE}
  echo
  for k in ${CPO_RELDB_KEYS[@]}; do printf "https://music.apple.com/us/song/%-10s . %s\n" $k $CPO_RELDB_FIELD_TITLE[$k]; done
  echo
}

# cpo_transpose_one_key $1=AMID $2=KEY $3=SEMITONE
cpo_transpose_one_key() {

  # command line options
  # https://metacpan.org/pod/App::Music::ChordPro
  # https://www.chordpro.org/chordpro/using-chordpro/

  INDEX=$(printf %02d $CPO_RELDB_KEYS[(I)$1])
  TITLE=${CPO_RELDB_FIELD_TITLE[$1]//" "/.}
  
  CPO_CMD=(
    /opt/homebrew/opt/perl/bin/chordpro
    --config=conf.prp
    # --config=$1.prp
    --diagrams=none
    -x $3
    -o out/$INDEX-$2-$TITLE-$1.pdf
    # -o out/test.pdf
    $1.cho
  )
  if [ -e $1.prp ]; then
    CPO_CMD+=(--config=$1.prp)
  fi
  ${CPO_CMD[@]}

}

# https://en.wikipedia.org/wiki/Circle_of_fifths
# cpo_transpose_all $1=AMID
cpo_allkeys_onesong() {
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

cpo_onekey_onesong() {
  cpo_transpose_one_key $1 C_ '0'
}

cpo_onekey_allsongs() {
  for i in *.cho; do
    cpo_onekey_onesong ${i:r}
    echo
  done
}

cpo_allkeys_allsongs() {
  for i in *.cho; do
    cpo_allkeys_onesong ${i:r}
  done
}

cpo_allkeys_allsongs_parallel() {

  F1=$(functions cpo_db_print)
  F2=$(functions cpo_transpose_one_key)
  F3=$(functions cpo_allkeys_onesong)

  # (bash) https://stackoverflow.com/questions/12944674/
  # (zsh) https://zsh.sourceforge.io/Doc/Release/Shell-Builtin-Commands.html#index-typeset
  declare -x CPO_RELDB_DUMPFILE=$(gmktemp /tmp/cpo_tmp_XXXXXXXXXX) # create temporary variable 
  echo $CPO_RELDB_DUMPFILE
  cpo_reldb_dump >$CPO_RELDB_DUMPFILE
  cat $CPO_RELDB_DUMPFILE

  ls -1 *.cho \
    | cut -f 1 -d '.' \
    | gtime -f "\n  wall clock time - %E - %e  \n" /opt/homebrew/opt/parallel/bin/parallel -I{} \
    -- zsh -c ":; source $CPO_RELDB_DUMPFILE; eval $F1; eval $F2; eval $F3; cpo_allkeys_onesong {}"

  grm -fv $CPO_RELDB_DUMPFILE

}

cpo_main() {

  cpo_db_init
  cpo_db_print

  cpo_onekey_allsongs

  # cpo_allkeys_allsongs
  # cpo_allkeys_allsongs_parallel

  gfind out/ | gsort

}

cpo_main; exit
