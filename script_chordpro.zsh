#!/bin/zsh -e

# https://zsh.sourceforge.io/Doc/Release/Parameters.html#Array-Parameters

# cpo_transpose_one_key $1=AMID $2=KEY $3=SEMITONE [$4=COPY_TO_FAVORITE_FORDER]
cpo_transpose_one_key() {

  # command line options
  # https://metacpan.org/pod/App::Music::ChordPro
  # https://www.chordpro.org/chordpro/using-chordpro/

  local INDEX=$(printf %02d $CPO_RELDB_KEYS[(I)$1])
  local AMBPM=${CPO_RELDB_FIELD_AMBPM[$1]}
  local TITLE=${CPO_RELDB_FIELD_TITLE[$1]}
  local TITLE_CANONICALIZED=${CPO_RELDB_FIELD_TITLE[$1]//" "/.}

  local OUT=$CPO_OUT/everything/$INDEX-$2-$TITLE_CANONICALIZED-$1.pdf

  local CMD=(
  
    /opt/homebrew/opt/perl/bin/chordpro
    --config=conf.prp
    # --config=$1.prp
    --diagrams=none
  
    --meta title=$TITLE
    --meta tempo=$AMBPM
  
    -x $3
  
    -o $OUT
    # -o $CPO_OUT/test.pdf
    $1.cho

  )

  [ -e $1.prp ] && CMD+=(--config=$1.prp)

  if [ 1 != $CPO_NO_INCREMENTAL ] && [ $OUT -nt $1.cho ]; then
    echo skip because $1 older than $OUT
  else
    $CMD[@]
  fi

  if [[ favorite == $4 ]]; then
    gcp -vf $OUT $CPO_OUT/
  fi

}

# https://en.wikipedia.org/wiki/Circle_of_fifths
# cpo_allkeys_onesong $1=AMID
cpo_allkeys_onesong() {
  local KEY_OFFSET=('+6' '+11' '+4' '+9' '+2' '+7' 0  '-7' '-2' '-9' '-4' '-11' '-6')
  local KEY_SYMBOL=(  Fi    B_   E_   A_   D_   G_ C_   F_   Bb   Eb   Ab    Db   Gb)
  [[ $#KEY_OFFSET == 13 ]] || { echo err c0i8cm; exit 1; }
  [[ $#KEY_SYMBOL == 13 ]] || { echo err z0djmc; exit 1; }
  for ((i=1; i<=13; i++)); do
    local CPO_CMD=(cpo_transpose_one_key $1 $KEY_SYMBOL[$i] $KEY_OFFSET[$i])
    if [[ $KEY_SYMBOL[$i] == $CPO_RELDB_FIELD_MPTKEY[$1] ]]; then
      CPO_CMD+=(favorite)
      $CPO_CMD[@]
    else
      [[ 1 == $CPO_SUPPRESS_EVERYTHING ]] || $CPO_CMD[@]
    fi
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

  local F1=$(functions cpo_reldb_print)
  local F2=$(functions cpo_transpose_one_key)
  local F3=$(functions cpo_allkeys_onesong)

  # (bash) https://stackoverflow.com/questions/12944674/
  # (zsh) https://zsh.sourceforge.io/Doc/Release/Shell-Builtin-Commands.html#index-typeset
  local CPO_RELDB_DUMPFILE=$(gmktemp /tmp/cpo_tmp_XXXXXXXXXX) # create temporary variable 
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

  source reldb.zshrc
  # cpo_reldb_print

  # cpo_allkeys_onesong 1566041338

  # cpo_onekey_allsongs
  # cpo_allkeys_allsongs
  cpo_allkeys_allsongs_parallel

  # gfind $CPO_OUT/ | gsort

}

cpo_main; exit
