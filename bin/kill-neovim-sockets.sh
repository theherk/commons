#!/usr/bin/env fish

if contains -- --deep $argv
  for x in (fd --type s _neovim $HOME 2>/dev/null)
    rm $x
  end
else
  for x in (fd --type s --max-depth 1 _neovim (cat ~/.projects) 2>/dev/null)
    rm $x
  end
end
