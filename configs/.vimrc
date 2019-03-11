set nocompatible  " set no compatible with old version of VI

syntax enable

set ruler " show the cursor position all the time
set showmatch " highlight matching braces
set showmode " show insert/replace/visual mode
set number  " show line numbers
set colorcolumn=80  " show a vertical line at column 80

set background=dark
colorscheme solarized

set autoindent

set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab

" Search down into subfolders
set path+=**
" Display all matching files when we tab complete
set wildmenu
" required for better searching
filetype plugin on

inoremap " ""<left>
inoremap ' ''<left>
inoremap ( ()<left>
inoremap [ []<left>
inoremap { {}<left>
inoremap {<CR> {<CR>}<ESC>O
inoremap {;<CR> {<CR>};<ESC>O

" other programming languages
au BufNewFile,BufRead *.java, *.c, *.h, *.cpp, *.hpp, *.html, *.css, *.xml
    \ set tabstop=2 |
    \ set softtabstop=2 |
    \ set shiftwidth=2 |
    \ set colorcolumn=100
