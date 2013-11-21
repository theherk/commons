set background=dark
colorscheme solarized

if has("gui_gtk2")
  set guifont=Inconsolata\ for\ Powerline\ 14
elseif has("gui_macvim")
  set guifont=Menlo\ Regular:h14
elseif has("gui_win32")
  set guifont=Consolas:h11:cANSI
endif

" set guioptions-=m  "remove menu bar
set guioptions-=T  "remove toolbar
" set guioptions-=r  "remove right-hand scroll bar

