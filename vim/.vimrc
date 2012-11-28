set nocompatible

" setup Vundle
set rtp+=~/.vim/vundle.git/
call vundle#rc()

Bundle "rails.vim"
Bundle "ack.vim"
Bundle 'JSON.vim'
Bundle 'LustyJuggler'
Bundle 'The-NERD-tree'
Bundle 'ruby.vim'
Bundle 'snipMate'
Bundle 'git://git.wincent.com/command-t.git'
"Bundle 'git://github.com/astashov/vim-ruby-debugger.git'
"Bundle 'CamelCaseMotion'
"Bundle 'CamelCaseComplete'
"Bundle 'Conque'

set expandtab
set tabstop=2
set shiftwidth=2
filetype plugin indent on 
set encoding=utf-8
set nowrap

set undofile
set hlsearch

syntax on

map <silent> <A-1> <ESC>:NERDTreeToggle<CR>
nmap <silent> <C-S> <ESC>:w<CR>
imap <silent> <C-S> <ESC>:w<CR>
nmap g* :Ack -w <C-R><C-W><space>
nmap <C-a> :Ack -w <C-R><C-W><space><CR>
map <silent> <C-Tab> <ESC>:LustyJugglePrevious<CR>
map <silent> <F3> <ESC>:LustyJuggler<CR>
map <silent> <leader>q <ESC>:NERDTreeFind<CR>

map <C-J> <C-W>j<C-W>_
map <C-K> <C-W>k<C-W>_ 
map <C-H> <C-W>h<C-W>_ 
map <C-L> <C-W>l<C-W>_ 
map <C-C> <C-W>c 
map <leader>a <Esc>:A
map <leader>r <Esc>:R<CR>
nnoremap <silent><BS> :nohlsearch<CR>

imap <C-Space> <C-n>

" Disable arrow keys
map <Left> :echo "h"<CR>
map <Right> :echo "l"<CR>
map <Up> :echo "k"<CR>
map <Down> :echo "j"<CR>

cnoremap %% <C-R>=expand('%:h').'/'<CR>

colorscheme railscasts

let g:ConqueTerm_ReadUnfocused = 1
let g:ConqueTerm_InsertOnEnter = 0

command C !ctags -R

"remove spaces at end of lines
autocmd FileType c,cpp,java,php,javascript,haskell,ruby autocmd BufWritePre <buffer> :%s/\s\+$//e

autocmd BufReadPost *
      \ if line("'\"") > 0 && line("'\"") <= line("$") |
      \    exe "normal g`\"" |
      \  endif

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
