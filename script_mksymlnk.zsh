#!/bin/zsh -e

source reldb.zshrc

cpo_reldb_print

cd tmpd.audio

for id in ${CPO_RELDB_KEYS[@]}; do
  TC=${CPO_RELDB_FIELD_TITLE[$id]//" "/.}
  for ext in m4a flac; do
    if gtest -e ../$id.$ext; then
      gln -sv ../$id.$ext $id-$TC.$ext
    else
      gtrue
    fi
  done
done
