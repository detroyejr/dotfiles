" No vi compatibility
set nocompatible
filetype off

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" Use airline plugin
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'

" Extra Color Schemes
Plugin 'sonph/onehalf', {'rtp': 'vim/'}

" Python Jedi for Vim
Plugin 'davidhalter/jedi-vim'

" All of your Plugins must be added before the following line
call vundle#end()

" Set color options
if !has("gui_running")
  set term=xterm
  set t_Co=256
  let &t_AB="\e[48;5;%dm"
  let &t_AF="\e[38;5;%dm"
  colorscheme onehalflight
  let g:airline_theme="onehalflight"
  set cursorline
endif

" Lanugage syntax on.
syntax on

" Set working directory as a path for searching with :find.
set path+=**

" Open a file with b. You can open files without typing the full name.
set wildmenu
" Tab completion
set wildmode=longest,list,full

" Tab options.
set tabstop=2
set shiftwidth=2
set expandtab

" Indentation
filetype plugin indent on
set autoindent
set smartindent

" Line options
set number
set relativenumber
set showcmd

" Set visual line wrap
set colorcolumn=81

" Split options
set splitbelow
set splitright

" Auto comment
set formatoptions+=r

" Movement mappings
map <C-J> <C-W>j<C-W>_
map <C-K> <C-W>k<C-W>_

" Set net_rw options.
let g:netrw_banner=0        " disable annoying banner
let g:netrw_browse_split=4  " open in prior window
let g:netrw_altv=1          " open splits to the right
let g:netrw_liststyle=3     " tree view
let g:netrw_list_hide=netrw_gitignore#Hide()
let g:netrw_list_hide.=',\(^\|\s\s\)\zs\.\S\+'

" Set options for YouCompleteMe
let g:ycm_python_binary_path = "python"
