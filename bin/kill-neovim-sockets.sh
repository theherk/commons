#!/usr/bin/env fish

for x in (fd --type s _neovim)
  rm $x
end
