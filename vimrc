let Cscope_OpenQuickfixWindow = 1
let Cscope_AutoClose = 1
let Cscope_TagOrder = 0

set tags=/dev/null

"added for omnicomplete
"set nocp
"filetype plugin on

" attempt to use global copy buffer as default
set clipboard=unnamed

"set list
set listchars=tab:>-,trail:-

set number

if version >= 730
	set autochdir
endif

"don't clear the screen
"set t_ti= t_te=

let g:view = "none"
function! AddPath()
    let s:view_idx = stridx($PWD, "/view/")
    if s:view_idx == 0
        let s:slash_idx = stridx($PWD, "/", 6)
        if s:slash_idx > 0
            let g:view = strpart($PWD, 6, s:slash_idx - 6)
        endif
    endif
    return g:view
endfunction

call AddPath()
execute "set path+=/view/".g:view."/vobs/fw-bsd/src/include/**"
execute "set path+=/view/".g:view."/vobs/fw-bsd/src/sys/**"
execute "set path+=/view/".g:view."/vobs/fw-bsd/src/sys/amd64/include/**"
execute "set path+=/view/".g:view."/vobs/fw/include/**"

execute "set path+=/view/".g:view."/vobs/fw/drvr/ident/**"
execute "set path+=/view/".g:view."/vobs/fw/support/hal/**"
execute "set path+=/view/".g:view."/vobs/fw/support/ident/**"


execute "set path+=/view/".g:view."/vobs/fw-vendor/mockpp/**"

set path+=$PWD/**

:ca Q q
:ca X x
:ca W w
:ca Edit edit

:map <C-c> :close<CR>
:map <C-f> :NERDTree<CR>
"Fix VIM corruption in TMUX when using NERDTree
let g:NERDTreeDirArrows = 0

"keys to move around windows
:map <C-h> <C-w>h
:map <C-j> <C-w>j
:map <C-k> <C-w>k
:map <C-l> <C-w>l

set t_Co=256
set background=dark
colorscheme jellybeans

if has('gui_running')
  set guioptions-=T  " no toolbar
  set lines=65 columns=95
  set guifont=Courier\ 10\ Pitch\ 10
  set guioptions+=e
  set guitablabel=%M\ %t
  winpos 100 40
  source $VIMRUNTIME/mswin.vim
  behave mswin
else
  " Set n lines to the cursor - when moving vertically using j/k
  set so=5
endif

"return to last line
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

autocmd BufRead,BufNewFile sv.* set filetype=sh
autocmd BufRead,BufNewFile *.svpp set filetype=sh
autocmd BufRead,BufNewFile *.subr set filetype=sh
au BufRead * if getline(1) == "#!/bin/bash" | set filetype=sh | endif
au BufRead * if getline(1) == "#!/bin/sh" | set filetype=sh | endif
"autocmd BufRead,BufNewFile *.txt,*.email set spell | syn off | endif
autocmd BufRead,BufNewFile aparco.ccase.tmp.* set spell | syn off | endif
autocmd BufRead,BufNewFile checkinMail.* set spell | syn off | endif

:autocmd BufRead,BufNewFile */checklist/checklist_*.temp* %s/!!! FILL IN !!!/N\/A/g

augroup reload_vimrc " {
    autocmd!
    autocmd BufWritePost ~/.vimrc source ~/.vimrc
augroup END " }

let mapleader=","

"Paste Mode
nnoremap <F2> :set invpaste paste?<CR>
set pastetoggle=<F2>
set showmode

"retain shift selection after shifting
vnoremap > >gv
vnoremap < <gv

"One > or < will shift in/out
nnoremap > >>
nnoremap < <<

"line break at cursor location
"nmap <CR> i<Enter><Esc>

"Cursor stuff
set cursorline

" Change Color when entering Insert Mode
autocmd InsertEnter * highlight  CursorLine ctermbg=232 guibg=#0D0D0D
" Revert Color to default when leaving Insert Mode
autocmd InsertLeave * highlight  CursorLine ctermbg=233 guibg=#1c1c1c

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => General
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Sets how many lines of history VIM has to remember
set history=100

" Enable filetype plugins
filetype on
filetype plugin on
filetype indent on

" Set to auto read when a file is changed from the outside
set autoread


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => VIM user interface
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Turn on the WiLd menu
set wildmenu

" Ignore compiled files
set wildignore=*.o,*~,*.pyc

"Always show current position
set ruler

" Height of the command bar
set cmdheight=1

" A buffer becomes hidden when it is abandoned
set hid

" Configure backspace so it acts as it should act
set backspace=eol,start,indent
set whichwrap+=<,>,h,l

" Ignore case when searching
set ignorecase

" When searching try to be smart about cases 
set smartcase

" Highlight search results
set hlsearch

" Makes search act like search in modern browsers
set incsearch

" Don't redraw while executing macros (good performance config)
set lazyredraw

" For regular expressions turn magic on
set magic

" Show matching brackets when text indicator is over them
set showmatch
" How many tenths of a second to blink when matching brackets
set mat=2

" No annoying sound on errors
set noerrorbells
set novisualbell
set t_vb=
set tm=200 "set timeout small for esc hjkl problem


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Colors and Fonts
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Enable syntax highlighting
syntax enable

" Set utf8 as standard encoding and en_US as the standard language
set encoding=utf8

" Use Unix as the standard file type
set ffs=unix,dos,mac


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Files, backups and undo
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Turn backup off, since most stuff is in SVN, git et.c anyway...
set nobackup
set nowb
set noswapfile


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Text, tab and indent related
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Use spaces instead of tabs
set expandtab

" Be smart when using tabs ;)
set smarttab

" 1 tab == 4 spaces
set shiftwidth=4
set tabstop=4

autocmd BufRead,BufNewFile */vobs/fw-bsd/* set tabstop=8|set shiftwidth=8|set noexpandtab

" Linebreak on 500 characters
set lbr
set tw=500

set ai "Auto indent
set si "Smart indent
set wrap "Wrap lines
set cindent


""""""""""""""""""""""""""""""
" => Visual mode related
""""""""""""""""""""""""""""""
" Visual mode pressing * or # searches for the current selection
vnoremap <silent> * :call VisualSelection('f')<CR>
vnoremap <silent> # :call VisualSelection('b')<CR>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Moving around, tabs, windows and buffers
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Treat long lines as break lines (useful when moving around in them)
map j gj
map k gk

" Return to last edit position when opening files (You want this!)
autocmd BufReadPost *
     \ if line("'\"") > 0 && line("'\"") <= line("$") |
     \   exe "normal! g`\"" |
     \ endif
" Remember info about open buffers on close
set viminfo^=%


""""""""""""""""""""""""""""""
" => Status line
""""""""""""""""""""""""""""""
" Always show the status line
set laststatus=1

" Format the status line
"set statusline=\ %{HasPaste()}%F%m%r%h\ %w\ \ CWD:\ %r%{getcwd()}%h\ \ \ Line:\ %l
set statusline+=%F

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Editing mappings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Remap VIM 0 to first non-blank character
"map 0 ^

"map <M-j> <C-j>

" Move a line of text using ALT+[jk] or Comamnd+[jk] on mac
nmap <M-j> mz:m+<cr>`z
nmap <M-k> mz:m-2<cr>`z
vmap <M-j> :m'>+<cr>`<my`>mzgv`yo`z
vmap <M-k> :m'<-2<cr>`>my`<mzgv`yo`z

" For Mac in iTerm2
nmap <ESC>j mz:m+<cr>`z
nmap <ESC>k mz:m-2<cr>`z
vmap <ESC>j :m'>+<cr>`<my`>mzgv`yo`z
vmap <ESC>k :m'<-2<cr>`>my`<mzgv`yo`z

if has("mac") || has("macunix")
  nmap <D-j> <M-j>
  nmap <D-k> <M-k>
  vmap <D-j> <M-j>
  vmap <D-k> <M-k>
endif

" Delete trailing white space on save, useful for Python and CoffeeScript ;)
func! DeleteTrailingWS()
  exe "normal mz"
  %s/\s\+$//ge
  exe "normal `z"
endfunc
autocmd BufWrite *.py :call DeleteTrailingWS()
autocmd BufWrite *.coffee :call DeleteTrailingWS()

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Spell checking
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Pressing ,ss will toggle and untoggle spell checking
map <leader>ss :setlocal spell!<cr>



"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Helper functions
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! HeaderFunc()
  let gatename = substitute(toupper(expand("%:t")), "\\.", "_", "g")
  let filename = expand("%:t")
  execute "normal! O#ifndef " . gatename
  execute "normal! o#define " . gatename . " "
  execute "normal! o"
  execute "normal! o"
  execute "normal! Go#endif /* " . gatename . " */"
  execute "normal! 2k"
endfunction
command! Headers call HeaderFunc()
autocmd BufNewFile *.{h,hpp} :call HeaderFunc()

function! CmdLine(str)
    exe "menu Foo.Bar :" . a:str
    emenu Foo.Bar
    unmenu Foo
endfunction

function! VisualSelection(direction) range
    let l:saved_reg = @"
    execute "normal! vgvy"

    let l:pattern = escape(@", '\\/.*$^~[]')
    let l:pattern = substitute(l:pattern, "\n$", "", "")

    if a:direction == 'b'
        execute "normal ?" . l:pattern . "^M"
    elseif a:direction == 'gv'
        call CmdLine("vimgrep " . '/'. l:pattern . '/' . ' **/*.')
    elseif a:direction == 'replace'
        call CmdLine("%s" . '/'. l:pattern . '/')
    elseif a:direction == 'f'
        execute "normal /" . l:pattern . "^M"
    endif

    let @/ = l:pattern
    let @" = l:saved_reg
endfunction


" Returns true if paste mode is enabled
function! HasPaste()
    if &paste
        return 'PASTE MODE  '
    en
    return ''
endfunction

" Don't close window, when deleting a buffer
command! Bclose call <SID>BufcloseCloseIt()
function! <SID>BufcloseCloseIt()
   let l:currentBufNum = bufnr("%")
   let l:alternateBufNum = bufnr("#")

   if buflisted(l:alternateBufNum)
     buffer #
   else
     bnext
   endif

   if bufnr("%") == l:currentBufNum
     new
   endif

   if buflisted(l:currentBufNum)
     execute("bdelete! ".l:currentBufNum)
   endif
endfunction
