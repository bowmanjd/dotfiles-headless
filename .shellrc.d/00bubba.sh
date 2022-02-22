#!/bin/sh

if [ -d $HOME/.bubba.d ]; then
  for rc in ~/.bubba.d/*; do
    if [ -f "$rc" ]; then
      . <(gpg --decrypt --quiet "$rc")
    fi
  done
fi
unset rc
