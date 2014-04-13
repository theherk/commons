" Vim color file
"
" Author: Edwin Pujols <edwinpm5@gmail.com>
"
"

hi clear   

if version > 580
    " no guarantees for version 5.8 and below, but this makes it stop
    " complaining
    hi clear   
    if exists("syntax_on")
        syntax reset
    endif
endif
let g:colors_name="bluecloud"
set background=dark

hi ColorColumn     guifg=#ff0000 guibg=#0c1c33 ctermfg=196 ctermbg=237 
hi LineNr          guifg=#2a62b2 guibg=#0c1c33 ctermfg=238 ctermbg=235 
hi NonText         guifg=#16345e guibg=#0c1c33 ctermfg=238 ctermbg=235 
hi Normal          guifg=#bfcfcf guibg=#16345e ctermfg=251 ctermbg=238 
hi Comment         guifg=#3274d4 ctermfg=245  
hi Boolean         guifg=#a7dd50 ctermfg=156  
hi Character       guifg=#73c216 ctermfg=112  
hi Number          guifg=#a7dd40 ctermfg=149  
hi String          guifg=#87cd40 ctermfg=113  
hi Conditional     guifg=#60e0ef               gui=bold ctermfg=80  cterm=bold
hi Constant        guifg=#8f8fc5               gui=bold ctermfg=105  cterm=bold
hi Cursor          guifg=#16345e guibg=#e0e0e0 ctermfg=239 ctermbg=188 
hi CursorLine                    guibg=#142d52 gui=none ctermbg=237 cterm=none 
hi CursorColumn                  guibg=#142d52  ctermbg=237 
hi CursorLineNr    guifg=#aad262 guibg=#0c1c33 gui=none ctermfg=149 ctermbg=236 cterm=none
hi Debug           guifg=#bca3a3               gui=bold ctermfg=145  cterm=bold
hi Define          guifg=#e4cc47 ctermfg=185  
hi Delimiter       guifg=#8f8f8f ctermfg=245  
hi DiffAdd                       guibg=#103030 ctermbg=233
hi DiffChange      guifg=#080800 guibg=#404030 ctermfg=232 ctermbg=52 
hi DiffDelete      guifg=#302020 guibg=#000000 ctermfg=235 ctermbg=16 
hi DiffText                      guibg=#420000 gui=none ctermbg=17 cterm=none

hi Directory       guifg=#a09fdf               gui=bold ctermfg=146  cterm=bold
hi Error           guifg=#960050 guibg=#1e0010 ctermfg=197 ctermbg=52
hi ErrorMsg        guifg=#ff0050 guibg=#1e0010 gui=bold ctermfg=196 ctermbg=16 cterm=bold
hi Exception       guifg=#ffaf20               gui=bold ctermfg=214  cterm=bold
hi Float           guifg=#87dd40 ctermfg=113  
hi FoldColumn      guifg=#173561 guibg=#07111f ctermfg=238 ctermbg=234 
hi Folded          guifg=#285ca8 guibg=#112747 ctermfg=60 ctermbg=236 
hi Function        guifg=#ec8763 ctermfg=173  
hi Identifier      guifg=#dcb070 ctermfg=179  
hi Ignore          guifg=#808080 guibg=#16345e ctermfg=244 ctermbg=239 
hi IncSearch       guifg=#000000 guibg=#ffff00 gui=none ctermfg=16 ctermbg=226 cterm=none

hi Keyword         guifg=#80b8bc               gui=bold ctermfg=109  cterm=bold
hi Label           guifg=#df7aff               gui=none ctermfg=177  cterm=none
hi Macro           guifg=#c4be89               gui=none ctermfg=144  cterm=none
hi SpecialKey      guifg=#e4cc47               gui=none ctermfg=185  cterm=none

hi MatchParen      guifg=#000000 guibg=#fd971f gui=bold ctermfg=16 ctermbg=208 cterm=bold
hi ModeMsg         guifg=#4a9cff ctermfg=75  
hi MoreMsg         guifg=#e4cc47 ctermfg=185  
hi Operator        guifg=#a0a0f0 ctermfg=147  

" complete menu
hi Pmenu           guifg=#e4cc47 guibg=#000000 ctermfg=185 ctermbg=16 
hi PmenuSel        guifg=#e4cc47 guibg=#000000 gui=reverse ctermfg=185 ctermbg=16 cterm=reverse
hi PmenuSbar                     guibg=#080808  ctermbg=232 
hi PmenuThumb      guifg=#e4cc47 ctermfg=185  

hi PreCondit       guifg=#ec6753               gui=none ctermfg=167  cterm=none
hi PreProc         guifg=#f0a0a0 ctermfg=217  
hi Question        guifg=#e4cc47               gui=bold ctermfg=185  cterm=bold
hi Repeat          guifg=#60e0ef               gui=bold ctermfg=80  cterm=bold
hi Search          guifg=#ffffff guibg=#d700af ctermfg=231 ctermbg=163 

" marks column
hi SignColumn      guifg=#ec6753 guibg=#232526 ctermfg=167 ctermbg=235 
hi SpecialChar     guifg=#df90b8               gui=none ctermfg=175  cterm=none
hi SpecialComment  guifg=#0088db               gui=bold ctermfg=32  cterm=bold
hi Special         guifg=#cfb032               gui=none ctermfg=179  cterm=none
hi SpecialKey      guifg=#c8aa85               gui=none ctermfg=180  cterm=none
if has("spell")
    hi SpellBad    guisp=#ff3030               gui=undercurl ctermfg=203 ctermbg=52 cterm=undercurl
    hi SpellCap    guisp=#f0c000               gui=undercurl ctermfg=178 ctermbg=52 cterm=undercurl
    hi SpellRare   guisp=#a540ff               gui=undercurl ctermfg=135 ctermbg=52 cterm=undercurl
    hi SpellLocal  guisp=#50df50               gui=undercurl ctermfg=108 ctermbg=52 cterm=undercurl
endif
hi Statement       guifg=#609fd3               gui=bold ctermfg=74  cterm=bold
hi StatusLine      guifg=#2a62b2 guibg=#000000 gui=bold ctermfg=25 ctermbg=16 cterm=bold
hi StatusLineNC    guifg=#141414 guibg=#103c67 ctermfg=233 ctermbg=239 
hi StorageClass    guifg=#ffa71f               gui=none ctermfg=214  cterm=none
hi Structure       guifg=#e4cc47 ctermfg=185  
hi Tag             guifg=#00faff               gui=none ctermfg=51  cterm=none
hi TabLineSel      guifg=#2a62b2 guibg=#000000 gui=bold ctermfg=249 ctermbg=16 cterm=bold
hi TabLineFill     guifg=#0c1c33 guibg=#ff0000 ctermfg=236 ctermbg=196 
hi TabLine         guifg=#544a80 guibg=#0c1c33 gui=none ctermfg=60 ctermbg=236 cterm=none
hi Title           guifg=#bf909a guibg=#112747 gui=bold ctermfg=138 ctermbg=237 cterm=bold
hi Todo            guifg=#e4cc47 guibg=#000000 gui=bold ctermfg=185 ctermbg=16 cterm=bold

hi Typedef         guifg=#e4cc47 ctermfg=185  
hi Type            guifg=#e4cc47               gui=none ctermfg=185  cterm=none
hi Underlined      guifg=#b3b4b4               gui=underline ctermfg=249  cterm=underline

hi VertSplit       guifg=#10304c guibg=#0a0a0a gui=bold ctermfg=236 ctermbg=232 cterm=bold
hi VisualNOS       guifg=#70a0ff guibg=#000f30 gui=none ctermfg=73 ctermbg=23 cterm=none
hi Visual          guifg=#70a0ff guibg=#000f30 gui=none ctermfg=75 ctermbg=17 cterm=none
hi WarningMsg      guifg=#000000 guibg=#ffaf00 gui=bold ctermfg=16 ctermbg=214 cterm=bold
hi WildMenu        guifg=#e4cc47 guibg=#000000 ctermfg=185 ctermbg=16 

hi helpCommand        guifg=#ffffff ctermfg=231  
hi helpExample        guifg=#70a0ff ctermfg=75  
hi helpNote           guifg=#f0f050 guibg=#000000 gui=bold ctermfg=227 ctermbg=16 cterm=bold
hi NERDTreeLink       guifg=#a2d23c ctermfg=149  
hi NERDTreeExecFile   guifg=#ec7753 ctermfg=173  
hi NERDTreeOpenable   guifg=#ec7753 ctermfg=173  
hi NERDTreeRO         guifg=#a0ac00 guibg=#202122 gui=none ctermfg=95 ctermbg=236 cterm=none
hi NERDTreeToggleOff  guifg=#3274d4 guibg=#1c1c1c gui=none ctermfg=68 ctermbg=234 cterm=none
hi NERDTreeToggleOn   guifg=#e4cc47 guibg=#080808 gui=bold ctermfg=185 ctermbg=232 cterm=bold
hi pythonBuiltin      guifg=#cfa555 ctermfg=179  
hi pythonSpaceError   guifg=#ffff00 guibg=#ff0000 ctermfg=226 ctermbg=196 
hi texStatement       guifg=#afc25f               gui=none ctermfg=143  cterm=none
