set background=dark
set cursorline

" File operation
set hidden
set autoread
set nobackup
set noswapfile
set encoding=utf-8
set laststatus=1

" Search
set incsearch
set hlsearch " Highlightning target
set showmode

" Indent
set autoindent
set smartindent
set smarttab
set expandtab
set cindent

" Not use tab normally
set tabstop=2
set softtabstop=2
set shiftwidth=2
set backspace=indent,eol,start

" Command
set cmdheight=1
set showcmd
set showmatch

" Ruler
set number
set ruler
set ignorecase

" No beep
set vb t_vb=

" Spell check
" set spell
" set spelllang=en,cjk

set clipboard+=unnamedplus
if has('mouse')
  set mouse=
endif

set list listchars=tab:¦_

" ===========================================================
" disable default plugins

let g:loaded_gzip              = 1
let g:loaded_tar               = 1
let g:loaded_tarPlugin         = 1
let g:loaded_zip               = 1
let g:loaded_zipPlugin         = 1
let g:loaded_rrhelper          = 1
let g:loaded_2html_plugin      = 1
let g:loaded_vimball           = 1
let g:loaded_vimballPlugin     = 1
let g:loaded_getscript         = 1
let g:loaded_getscriptPlugin   = 1
let g:loaded_netrw             = 1
let g:loaded_netrwPlugin       = 1
let g:loaded_netrwSettings     = 1
let g:loaded_netrwFileHandlers = 1
"let g:loaded_matchparen        = 1
let g:loaded_LogiPat           = 1
let g:loaded_logipat           = 1
let g:loaded_tutor_mode_plugin = 1
let g:loaded_spellfile_plugin  = 1
let g:loaded_man               = 1
let g:loaded_matchit           = 1
