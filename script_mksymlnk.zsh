#!/bin/zsh -e

source reldb.zshrc

cpo_reldb_print

cd tmpd.audio

for k in ${CPO_RELDB_KEYS[@]}; do
  TC=${CPO_RELDB_FIELD_TITLE[$k]//" "/.}
  ln -sv ../$k.m4a $k-$TC.m4a
done
