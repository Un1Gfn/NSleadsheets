#!/bin/zsh -e

source /usr/local/share/homebrew/compat.zshrc
source reldb.zshrc

cpo_reldb_print

cd tmpd.audio

for id in ${CPO_RELDB_KEYS[@]}; do
  TC=${CPO_RELDB_FIELD_TITLE[$id]//" "/.}
  for ext in m4a flac; do
    if gtest -e ../$id.$ext; then
      ln -sv ../$id.$ext $id-$TC.$ext
    else
      true
    fi
  done
done
