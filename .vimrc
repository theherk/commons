set nocompatible
filetype plugin indent on

execute pathogen#infect()

syntax on

set background=dark
colorscheme solarized

if has("gui_running")
  if has("gui_gtk2")
    set guifont=Inconsolata\ for\ Powerline\ 14
  elseif has("gui_macvim")
    set guifont=Menlo\ Regular:h14
  elseif has("gui_win32")
    set guifont=Consolas:h11:cANSI
  endif
endif

set encoding=utf-8
set modelines=0
set autoindent
set showmode
set showcmd
set visualbell
set ruler
set nonumber
set norelativenumber
set laststatus=2
set history=1000
set undofile
set undoreload=10000
" set list
set showbreak=↪
set splitbelow
set splitright
set title
set linebreak
set colorcolumn=+1
set wildmenu "shows opions in complete menu
set wildmode=full

" Better Completion
set complete=.,w,b,u,t
set completeopt=longest,menuone,preview

" Search Preferences
set hlsearch "highlight search term
set ignorecase "case insensitive search
set smartcase "case insensitive unless there are capital letters
set incsearch "search as the term is typed

" Resize splits when the window is resized
au VimResized * :wincmd =

" Line Return {{{

" Make sure Vim returns to the same line when you reopen a file.
" Thanks, Amit
augroup line_return
    au!
    au BufReadPost *
        \ if line("'\"") > 0 && line("'\"") <= line("$") |
        \     execute 'normal! g`"zvzz' |
        \ endif
augroup END

" }}}

" Tabs, spaces, wrapping {{{

set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
set wrap
set textwidth=80

" }}}
" Backups {{{

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

" Convenience mappings ---------------------------------------------------- {{{

" Fuck you, help key.
noremap  <F1> <nop>
inoremap <F1> <nop>

" Stop it, hash key.
inoremap # X<BS>#

" Kill window
nnoremap K :q<cr>

" Man
nnoremap M K

" Toggle line numbers
nnoremap <leader>n :setlocal number!<cr>

" Sort lines
nnoremap <leader>s vip:!sort<cr>
vnoremap <leader>s :!sort<cr>

" Tabs
nnoremap <leader>( :tabprev<cr>
nnoremap <leader>) :tabnext<cr>

" Copying text to the system clipboard.
"
" For some reason Vim no longer wants to talk to the OS X pasteboard through "*.
" Computers are bullshit.
function! g:FuckingCopyTheTextPlease()
    let old_z = @z
    normal! gv"zy
    call system('pbcopy', @z)
    let @z = old_z
endfunction
noremap <leader>p :silent! set paste<CR>"*p:set nopaste<CR>
" noremap <leader>p mz:r!pbpaste<cr>`z
vnoremap <leader>y :<c-u>call g:FuckingCopyTheTextPlease()<cr>

" Select entire buffer
nnoremap vaa ggvGg_
nnoremap Vaa ggVG

" "Uppercase word" mapping.
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
" }}}

