set nocompatible

" setup Vundle
filetype off
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

Bundle 'gmarik/vundle'
Bundle "ack.vim"
Bundle 'JSON.vim'
Bundle 'ruby.vim'
Bundle 'git://github.com/tpope/vim-rails.git'
Bundle 'git://git.wincent.com/command-t.git'
Bundle 'git://github.com/bkad/CamelCaseMotion.git'
Bundle 'git://github.com/kchmck/vim-coffee-script.git'
Bundle 'git://github.com/uggedal/go-vim.git'
Bundle 'derekwyatt/vim-scala'
Bundle 'othree/html5.vim'

"Bundle "MarcWeber/vim-addon-mw-utils"
"Bundle "tomtom/tlib_vim"
"Bundle "garbas/vim-snipmate"
"Bundle "honza/vim-snippets"

filetype plugin indent on
set expandtab
set tabstop=2
set shiftwidth=2
set encoding=utf-8
set nowrap

set undofile
set hlsearch
set maxmempattern=16384


syntax on

"map <silent> <A-1> <ESC>:NERDTreeToggle<CR>
nmap <silent> <C-S> <ESC>:w<CR>
imap <silent> <C-S> <ESC>:w<CR>
nmap g* :Ack -w <C-R><C-W><space>
nmap <C-a> :Ack -w <C-R><C-W><space><CR>
"map <silent> <C-Tab> <ESC>:LustyJugglePrevious<CR>
"map <silent> <F3> <ESC>:LustyJuggler<CR>
"map <silent> <leader>q <ESC>:NERDTreeFind<CR>

" calling spin
map <leader>[ <ESC>:call CallSpin()<CR><CR>
map <leader>p <ESC>:call SetSpinCall(expand("%"), 0)<CR>:call CallSpin()<CR><CR>
map <leader>] <ESC>:call SetSpinCall(expand("%"), line("."))<CR>:call CallSpin()<CR><CR>

function SetSpinCall(filename, linenum)
  let g:spin_test_file = a:filename
  let g:spin_test_line = a:linenum
endfunction

function! CallSpin()
  if g:spin_test_line 
    execute "!spin push " . g:spin_test_file . ":" . g:spin_test_line
  else
    execute "!spin push " . g:spin_test_file
  endif
endfunction
      

map <C-J> <C-W>j<C-W>_
map <C-K> <C-W>k<C-W>_ 
map <C-H> <C-W>h<C-W>_ 
map <C-L> <C-W>l<C-W>_ 
map <C-C> <C-W>c 
nnoremap <silent><BS> :nohlsearch<CR>

imap <C-Space> <C-n>

" Disable arrow keys
map <Left> :echo "h"<CR>
map <Right> :echo "l"<CR>
map <Up> :echo "k"<CR>
map <Down> :echo "j"<CR>

cnoremap %% <C-R>=expand('%:h').'/'<CR>

colorscheme railscasts

command C !ctags -R

"remove spaces at end of lines
autocmd FileType c,cpp,java,php,javascript,haskell,ruby autocmd BufWritePre <buffer> :%s/\s\+$//e
autocmd BufReadPost *
      \ if line("'\"") > 0 && line("'\"") <= line("$") |
      \    exe "normal g`\"" |
      \  endif

" syntax higlight for .jst.ejs
au BufNewFile,BufRead *.ejs set filetype=html

" Replace word under coursor
map <leader>s "ayiw:%s/<C-R>a/

" Copy to system clipboard
map <leader>c "+y
" Paste from system clipboard
map <leader>v "+p

" Open command mode by hitting semicolon:
nnoremap ; :

" Jump to the next or previous line that has the same level or a lower
" level of indentation than the current line.
"
" exclusive (bool): true: Motion is exclusive
" false: Motion is inclusive
" fwd (bool): true: Go to next line
" false: Go to previous line
" lowerlevel (bool): true: Go to line with lower indentation level
" false: Go to line with the same indentation level
" skipblanks (bool): true: Skip blank lines
" false: Don't skip blank lines
function! NextIndent(exclusive, fwd, lowerlevel, skipblanks)
  let line = line('.')
  let column = col('.')
  let lastline = line('$')
  let indent = indent(line)
  let stepvalue = a:fwd ? 1 : -1
  while (line > 0 && line <= lastline)
    let line = line + stepvalue
    if ( ! a:lowerlevel && indent(line) == indent ||
          \ a:lowerlevel && indent(line) < indent)
      if (! a:skipblanks || strlen(getline(line)) > 0)
        if (a:exclusive)
          let line = line - stepvalue
        endif
        exe line
        exe "normal " column . "|"
        return
      endif
    endif
  endwhile
endfunction

" Moving back and forth between lines of same or lower indentation.
nnoremap <silent> [l :call NextIndent(0, 0, 0, 1)<CR>
nnoremap <silent> ]l :call NextIndent(0, 1, 0, 1)<CR>
nnoremap <silent> [L :call NextIndent(0, 0, 1, 1)<CR>
nnoremap <silent> ]L :call NextIndent(0, 1, 1, 1)<CR>
vnoremap <silent> [l <Esc>:call NextIndent(0, 0, 0, 1)<CR>m'gv''
vnoremap <silent> ]l <Esc>:call NextIndent(0, 1, 0, 1)<CR>m'gv''
vnoremap <silent> [L <Esc>:call NextIndent(0, 0, 1, 1)<CR>m'gv''
vnoremap <silent> ]L <Esc>:call NextIndent(0, 1, 1, 1)<CR>m'gv''
onoremap <silent> [l :call NextIndent(0, 0, 0, 1)<CR>
onoremap <silent> ]l :call NextIndent(0, 1, 0, 1)<CR>
onoremap <silent> [L :call NextIndent(1, 0, 1, 1)<CR>
onoremap <silent> ]L :call NextIndent(1, 1, 1, 1)<CR>

if $COLORTERM == 'gnome-terminal'
  set t_Co=256
endif

hi StatusLine   ctermbg=235 guibg=#1a1a1a cterm=bold gui=bold


" https://github.com/garybernhardt/dotfiles/blob/master/.vimrc
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" MULTIPURPOSE TAB KEY
" Indent if we're at the beginning of a line. Else, do completion.
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! InsertTabWrapper()
    let col = col('.') - 1
    if !col || getline('.')[col - 1] !~ '\k'
        return "\<tab>"
    else
        return "\<c-p>"
    endif
endfunction
inoremap <tab> <c-r>=InsertTabWrapper()<cr>
inoremap <s-tab> <c-n>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" RENAME CURRENT FILE
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! RenameFile()
    let old_name = expand('%')
    let new_name = input('New file name: ', expand('%'), 'file')
    if new_name != '' && new_name != old_name
        exec ':saveas ' . new_name
        exec ':silent !rm ' . old_name
        redraw!
    endif
endfunction
map <leader>n :call RenameFile()<cr>


