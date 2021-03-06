" archlinux.vim is probably located in /usr/share/vim/vimfiles/
" This line should not be removed as it ensures that various options are
" properly set to work with the Vim-related packages.
runtime! archlinux.vim
" If not present or unpleasant, there's also
" /usr/share/vim/vimXX/vimrc_example.vim

if has('nvim')
    " Neovim specific commands
else
    " Standard vim specific commands
endif

if empty(glob('$XDG_CONFIG_HOME/nvim/autoload/plug.vim'))
    silent !curl -fLo $XDG_CONFIG_HOME/nvim/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source $XDG_CONFIG_HOME/nvim/init.vim
endif

" plugins
call plug#begin('$XDG_CONFIG_HOME/nvim/plugged')
Plug 'neoclide/coc.nvim', {'branch': 'release'}
call plug#end()

" cursor settings
" if vi mode prefixes are not being set by readline, they will need to be set
" manually on vim exit using autocmds

" terminal cursor
if &term =~ "screen.*"
    " wrap in DECSCRSR when in screen/tmux
    let &t_SI = "\eP\e[5 q\e\\"
    let &t_SR = "\eP\e[3 q\e\\"
    let &t_EI = "\eP\e[1 q\e\\"
else
    " insert
    let &t_SI = "\e[5 q"
    " replace
    let &t_SR = "\e[3 q"
    " normal (and anything else)
    let &t_EI = "\e[1 q"
endif

" less ridiculous history (vim default is 10000)
set history=1000
" allow backspacing over everything in insert mode
set bs=indent,eol,start
" always show cursor coordinates
set ruler
" show matches as you are typing the search expression
set incsearch
" highlight matches when searching
set hlsearch
" enable statusline even for single files
set laststatus=2
" enable tabline even if there's only one tab
set showtabline=2
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
set listchars=tab:<\ >,eol:$,nbsp:+,trail:-
" enable mouse
set mouse=a
" show number of matches on the last line of the screen
set shortmess-=S
" clearing/refreshing the screen also gets rid of highlights
nnoremap <silent> <C-L> :nohls<CR>:set nolist<CR><C-L>

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

" pretty colors
colorscheme slate

if has('autocmd')
    " open all folds to start
    au Syntax * normal zR

    if &term =~ "screen.*"
        " wrap cursor escape sequences in DECSCRSR for screen/tmux
        au VimEnter * silent !echo -ne "\eP\e[1 q\e\\"
        au VimLeave * silent !echo -ne "\eP\e[3 q\e\\"
    else
        au VimEnter * silent !echo -ne "\e[1 q"
        au VimLeave * silent !echo -ne "\e[3 q"
    endif
endif
