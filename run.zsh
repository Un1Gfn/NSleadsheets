#!/bin/zsh -e

# https://zsh.sourceforge.io/Doc/Release/Parameters.html#Array-Parameters

# cpo_append $1=ASID $2=AMBPM $3=MPTKEY $4=TITLE
cpo_reldb_append() {
  CPO_RELDB_KEYS+=($1)
  CPO_RELDB_FIELD_AMBPM+=([$1]=$2)
  CPO_RELDB_FIELD_MPTKEY+=([$1]=$3)
  CPO_RELDB_FIELD_TITLE+=([$1]=$4)
}

cpo_reldb_dump() {
  declare -p1 CPO_RELDB_KEYS
  declare -p1 CPO_RELDB_FIELD_AMBPM
  declare -p1 CPO_RELDB_FIELD_MPTKEY
  declare -p1 CPO_RELDB_FIELD_TITLE
}

cpo_db_init() {

  declare -g -a CPO_RELDB_KEYS
  declare -g -A CPO_RELDB_FIELD_AMBPM
  declare -g -A CPO_RELDB_FIELD_MPTKEY
  declare -g -A CPO_RELDB_FIELD_TITLE

  # key symbol /[A-G][_ib]/
  # _ is NATUAL
  # i is SHARP
  # b is FLAT

  cpo_reldb_append 1566041338       "172" "D_" "House Of The Lord"
  cpo_reldb_append 993160497        "122" "G_" "Trading My Sorrows"
  cpo_reldb_append 655662082        "130" "E_" "You Are Good"

  cpo_reldb_append 1175720998       "120" "D_" "Way Maker"
  cpo_reldb_append 715720012        "156" "A_" "Worthy Is the Lamb"
  cpo_reldb_append 1019249219       "136" "A_" "There Is None Like You"

  cpo_reldb_append 1443158231       "128" "A_" "Amazing Grace My Chains Are Gone"
  cpo_reldb_append 1440837672 "(6/8) 100" "A_" "Good Good Father"
  cpo_reldb_append 1502316160       "142" "B_" "The Blessing"

  cpo_reldb_append 1192789624       "172" "G_" "Do It Again"

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

# cpo_transpose_one_key $1=AMID $2=KEY $3=SEMITONE [$4=COPY_TO_FAVORITE_FORDER]
cpo_transpose_one_key() {

  # command line options
  # https://metacpan.org/pod/App::Music::ChordPro
  # https://www.chordpro.org/chordpro/using-chordpro/

  local INDEX=$(printf %02d $CPO_RELDB_KEYS[(I)$1])
  local AMBPM=${CPO_RELDB_FIELD_AMBPM[$1]}
  local TITLE=${CPO_RELDB_FIELD_TITLE[$1]}
  local TITLE_CANONICALIZED=${CPO_RELDB_FIELD_TITLE[$1]//" "/.}

  local OUT=out/everything/$INDEX-$2-$TITLE_CANONICALIZED-$1.pdf
  
  local CMD=(
  
    /opt/homebrew/opt/perl/bin/chordpro
    --config=conf.prp
    # --config=$1.prp
    --diagrams=none
  
    --meta title=$TITLE
    --meta tempo=$AMBPM
  
    -x $3
  
    -o $OUT
    # -o out/test.pdf
    $1.cho

  )

  [ -e $1.prp ] && CMD+=(--config=$1.prp)

  if [ $OUT -nt $1.cho ]; then
    echo skip because $1 older than $OUT
  else
    $CMD[@]
  fi

  if [[ favorite == $4 ]]; then
    gcp -vf $OUT out/
  fi

}

# https://en.wikipedia.org/wiki/Circle_of_fifths
# cpo_allkeys_onesong $1=AMID
cpo_allkeys_onesong() {
  KEY_OFFSET=('+6' '+11' '+4' '+9' '+2' '+7' 0  '-7' '-2' '-9' '-4' '-11' '-6')
  KEY_SYMBOL=(  Fi    B_   E_   A_   D_   G_ C_   F_   Bb   Eb   Ab    Db   Gb)
  [[ $#KEY_OFFSET == 13 ]] || { echo err c0i8cm; exit 1; }
  [[ $#KEY_SYMBOL == 13 ]] || { echo err z0djmc; exit 1; }
  for ((i=1; i<=13; i++)); do
    local CPO_CMD=(cpo_transpose_one_key $1 $KEY_SYMBOL[$i] $KEY_OFFSET[$i])
    [[ $KEY_SYMBOL[$i] == $CPO_RELDB_FIELD_MPTKEY[$1] ]] && CPO_CMD+=(favorite)
    $CPO_CMD[@]
  done
  echo
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
  # cat $CPO_RELDB_DUMPFILE

  ls -1 *.cho \
    | cut -f 1 -d '.' \
    | gtime -f "\n  wall clock time - %E - %e  \n" /opt/homebrew/opt/parallel/bin/parallel -I{} \
    -- zsh -c ":; source $CPO_RELDB_DUMPFILE; eval $F1; eval $F2; eval $F3; cpo_allkeys_onesong {}"

  grm -fv $CPO_RELDB_DUMPFILE

}

cpo_main() {

  cpo_db_init
  # cpo_db_print

  # cpo_allkeys_onesong 1566041338

  # cpo_onekey_allsongs
  # cpo_allkeys_allsongs
  cpo_allkeys_allsongs_parallel

  gfind out/ | gsort

}

cpo_main; exit
