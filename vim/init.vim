" cursor settings
" if vi mode prefixes are not being set by readline, they will need to be set
" manually on vim exit using autocmds

set guicursor="n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50,a:blinkwait0-blinkoff600-blinkon600-Cursor/lCursor,sm:block-blinkwait0-blinkoff600-blinkon600"

" terminal cursor
if (&term =~ "tmux.*" || &term =~ "xterm.*")
	" insert
	let &t_SI = "\e[5 q"
	" replace
	let &t_SR = "\e[3 q"
	" normal (and anything else)
	let &t_EI = "\e[1 q"
elseif &term == "linux"
	" insert
	let &t_SI = "\e[?0;c"
	" normal (and anything else)
	let &t_EI = "\e[?8;c"
endif

" put backup, undo, and swap files in one place
set backupdir=$HOME/.vim/backup//
set undodir=$HOME/.vim/undo//
set directory=$HOME/.vim/swap//

" Copied from /usr/share/vim/vimXX/vimrc_example.vim

" Get the defaults that most users want.
source $VIMRUNTIME/defaults.vim

if has("vms")
	set nobackup		" do not keep a backup file, use versions instead
else
	set backup		" keep a backup file (restore to previous version)
	if has('persistent_undo')
		set undofile	" keep an undo file (undo changes after closing)
	endif
endif

if &t_Co > 2 || has("gui_running")
	" Switch on highlighting the last used search pattern.
	set hlsearch
endif

" Add optional packages.
"
" The matchit plugin makes the % command work better, but it is not backwards
" compatible.
" The ! means the package won't be loaded right away but when plugins are
" loaded during initialization.
if has('syntax') && has('eval')
	packadd! matchit
endif

" End /usr/share/vim/vimXX/vimrc_example.vim

" some of these settings may be redundant

set cedit=<C-O>
cnoremap <C-A> <Home>
cnoremap <C-F> <Right>
cnoremap <C-B> <Left>
cnoremap <C-X> <C-A>

" allow backspacing over everything in insert mode
set bs=indent,eol,start
" always show cursor coordinates
set ruler
" show matches as you are typing the search expression
set incsearch
" always show last command executed
set showcmd
" show matching brackets when the cursor is over one
set showmatch
" show current mode in statusline
set showmode
" turn on wild menu (command mode tab completion)
set wildmenu
" don't redraw screen when executing macros (increases performance)
set lazyredraw
" use magic regex
set magic
" automatically update file when changes are detected
set autoread
" characters to be changed in list mode
set listchars=tab:<~>,eol:$,nbsp:+,trail:-
" enable mouse
set mouse=a
" show number of matches on the last line of the screen
set shortmess-=S
" clearing/refreshing the screen also gets rid of highlights
nnoremap <silent> <C-L> :nohls<CR><C-L>

" no line numbers (use ruler instead)
set nonumber
" but do show relative numbers
set relativenumber
" allow text/break label to occupy the gutter
set cpoptions+=n
" shrink the min gutter size since numbers will never have more than 2 digits
set numberwidth=3
" wrap text
set wrap
" label for line breaks/wraps
set showbreak=\ >\ 

" turn on filetype detection
filetype on
" load plugin files
filetype plugin on
" load indent files
filetype indent on
" turn on auto indenting
set autoindent
" use c-style indenting (works for many languages)
set cindent
" On pressing tab, insert a bunch of spaces instead
set expandtab
" insert tabs smartly
set smarttab
" show actual tabs at 8 spaces width
set tabstop=8
" fake tabs are 4 spaces
set softtabstop=4
" number of characters of whitespaces to insert when indenting with '>'
set shiftwidth=4
" when indenting, round to a multiple of tab size
set shiftround

" enable default lexical/syntax highlighting
syntax on
" turn on folding and let syntax files handle it
set foldmethod=syntax
" C syntax options
let c_minlines = 100
let c_space_errors = 1
let c_curly_error = 1 " can be slow on large files

" syntax highlighting in .shrc
au BufNewFile,BufRead .shrc set filetype=sh
