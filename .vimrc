execute pathogen#infect()

set nocompatible
filetype plugin indent on

syntax on

set background=dark
colorscheme gruvbox

" Show airline in term
set t_Co=16

" Set syntax for Markdown
au BufNewFile,BufRead *.mkdown set filetype=markdown
au BufNewFile,BufRead *.md set filetype=markdown
au BufNewFile,BufRead *.txt set filetype=markdown

" Set syntax and configuration for HTML
au BufNewFile,BufRead *.html set filetype=html
au BufNewFile,BufRead *.htm set filetype=html
au FileType html setlocal sw=2 ts=2 sts=2

" Powerline Font support for Airline
let g:airline_powerline_fonts = 1

let mapleader=" "
set encoding=utf-8
set modelines=0
set autoindent
"set showmode
"set showcmd
set visualbell
"set ruler
set number
set relativenumber
set laststatus=2
set history=1000
set undofile
set undoreload=10000
"set listchars=eol:\ \,trail:·,tab:▸\ 
"set list
set showbreak=↪
set splitbelow
set splitright
set title
set linebreak
set colorcolumn=+1
set wildmenu "shows opions in complete menu
set wildmode=full

" Better Completion
" -----------------
set complete=.,w,b,u,t
set completeopt=longest,menuone,preview

" Search Preferences
" ------------------

set hlsearch "highlight search term
set ignorecase "case insensitive search
set smartcase "case insensitive unless there are capital letters
set incsearch "search as the term is typed

" Resize splits when the window is resized
" Tabular cause this to issue an error
" Error detected while processing VimResized Auto commands for \"*\":
" Not allowed here: :wincmd =
" au VimResized * :wincmd =

" Line Return
" -----------

" Make sure Vim returns to the same line when you reopen a file.
" Thanks, Amit
augroup line_return
    au!
    au BufReadPost *
        \ if line("'\"") > 0 && line("'\"") <= line("$") |
        \     execute 'normal! g`"zvzz' |
        \ endif
augroup END

" Tabs, spaces, wrapping
" ----------------------

set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
set wrap
set textwidth=0

" Backups
" -------

set backup                        " enable backups
set noswapfile                    " it's 2013, Vim.

set undodir=~/.vim/tmp/undo//     " undo files
set backupdir=~/.vim/tmp/backup// " backups
set directory=~/.vim/tmp/swap//   " swap files

" Make those folders automatically if they don't already exist.
if !isdirectory(expand(&undodir))
    call mkdir(expand(&undodir), "p")
endif
if !isdirectory(expand(&backupdir))
    call mkdir(expand(&backupdir), "p")
endif
if !isdirectory(expand(&directory))
    call mkdir(expand(&directory), "p")
endif

" Convenience mappings
" --------------------

" Fuck you, help key.
noremap  <F1> <nop>
inoremap <F1> <nop>

" Stop it, hash key.
inoremap # X<BS>#

" Man
nnoremap M K

" Toggle line numbers
nnoremap <leader>n :setlocal number!<cr>

" Tabs
nnoremap <leader>( :tabprev<cr>
nnoremap <leader>) :tabnext<cr>

" Select all
nnoremap Vaa ggVG

" Saving and quiting
nnoremap <leader>w :w<cr>
nnoremap <leader>q :q<cr>

" Colemak needs
" -------------

" Directions for a lefty Colemaker
noremap r k
noremap s j
noremap a h
noremap t l

" Top and bottom
noremap R H
noremap S L

" Line above and below
nnoremap j O
nnoremap k o

" New home for append
nnoremap o a
nnoremap O A

" Get with the program loser
map <up> <nop>
map <down> <nop>
map <left> <nop>
map <right> <nop>
imap <up> <nop>
imap <down> <nop>
imap <left> <nop>
imap <right> <nop>

" Uppercase word mapping.
"
" This mapping allows you to press <c-u> in insert mode to convert the current
" word to uppercase.  It's handy when you're writing names of constants and
" don't want to use Capslock.
"
" To use it you type the name of the constant in lowercase.  While your
" cursor is at the end of the word, press <c-u> to uppercase it, and then
" continue happily on your way:
"
"                            cursor
"                            v
"     max_connections_allowed|
"     <c-u>
"     MAX_CONNECTIONS_ALLOWED|
"                            ^
"                            cursor
"
" It works by exiting out of insert mode, recording the current cursor location
" in the z mark, using gUiw to uppercase inside the current word, moving back to
" the z mark, and entering insert mode again.
"
" Note that this will overwrite the contents of the z mark.  I never use it, but
" if you do you'll probably want to use another mark.
inoremap <C-u> <esc>mzgUiw`za

