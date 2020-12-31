" ----------------------------------------------------------------------------
" START
" ----------------------------------------------------------------------------
set nocompatible " be iMproved,  required
filetype off     " required

let os=substitute(system('uname'), '\n', '', '')
let isNeovim=has('nvim')

let VimDir="$HOME/.vim"
if has("win32") || has('win64')
    let VimDir="$HOME/vimfiles"
endif

let &rtp .= ',' . expand(VimDir . "/bundle/Vundle.vim")
let &backupdir=expand(VimDir . "/backups")
let &directory=expand(VimDir . "/swaps")
let &undodir=expand(VimDir . "/undo")

" -----------------------------------------------------------------------------
" Vundle plugins
" -----------------------------------------------------------------------------
" set the runtime path to include Vundle and initialize
call vundle#begin(expand(VimDir . "/bundle"))
    Plugin 'VundleVim/Vundle.vim' " let Vundle manage Vundle, required
    Plugin 'tpope/vim-fugitive' " plugin on GitHub repo
    Plugin 'preservim/nerdtree' " file system explorer
    Plugin 'ctrlpvim/ctrlp.vim' " full path fuzzy file/buffer/mru/tag finder
    Plugin 'flazz/vim-colorschemes' " one stop shop for vim colorschemes
    Plugin 'vim-airline/vim-airline'    " status bar
    Plugin 'vim-airline/vim-airline-themes'
    Plugin 'preservim/tagbar'   " tag list
"    Plugin 'ycm-core/YouCompleteMe' " fuzzy-search code completion
call vundle#end()            " required
filetype plugin indent on    " required
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
" see :h vundle for more details or wiki for FAQ

" ----------------------------------------------------------------------------
" EDITING
" ----------------------------------------------------------------------------

" Get the defaults that most users want.
if isNeovim == 0
    source $VIMRUNTIME/defaults.vim
endif

" VIM system settings
    set clipboard=unnamed   " Use the OS clipboard by default
    set wildmenu            " Enhance command-line completion
    set wildmode=longest,list,full
    set backspace=indent,eol,start " Allow backspace in insert mode
    set ttyfast             " Optimize for fast terminal connections
    set gdefault            " Add the g flag to search/replace by default
    set encoding=utf-8 nobomb " Use UTF-8 without BOM
    let mapleader=","       " Change mapleader
"

" Editting
    set expandtab       " replace tab with spaces
    set autoindent
    set tabstop=4
    set shiftwidth=4    " # of spaces to use for each step of (auto)indent
    set softtabstop=4   " # of spaces that a tab counts for while performing editing
    set textwidth=100   " maximum width of a line. Longer line will be broken into lines.
    set colorcolumn=+1  " highlight column after textwidth

    set backspace=indent,eol,start  " make backspace work like most other apps

    " searching
    set hlsearch    " Highlight searches
    set incsearch   " Highlight dynamically as pattern is typed
    set ignorecase  " Ignore case of searches
    set smartcase   " override the 'ignorecase' option if search pattern has upper case
"


" Automatic commands
if has("autocmd")
    filetype on " Enable file type detection
    " Treat .json files as .js
    autocmd BufNewFile,BufRead *.json setfiletype json syntax=javascript
    " Treat .md files as Markdown
    autocmd BufNewFile,BufRead *.md setlocal filetype=markdown
endif

" ----------------------------------------------------------------------------
" GUI
" ----------------------------------------------------------------------------
" Termimal UI
    set guifont=Consolas:h10,Courier_New:h10
    set number      " Enable line numbers
    if version == 800
        " VIM 8.0 had a bug so that cursorline and relativenumber are unusable
        set nocul nornu
    else
        set cursorline  " Highlight current line
        set relativenumber " Use relative line numbers
    endif
    " (list + listchars) shows “invisible” characters
    set list listchars=tab:>-,trail:-
    set showmatch   " show matching brackets/braces/parantheses

    set laststatus=2 " Always show status line
    set mouse=a     " Enable mouse in all modes
    " set noerrorbells " Disable error bells
    set errorbells
    set visualbell  " silence the bell, use a flash instead
    set nostartofline " Don’t reset cursor to start of line when moving around.
    set ruler       " Show the cursor position
    set wrap
    set shortmess=atI " Don’t show the intro message when starting Vim
    set showmode    " Show the current mode
    set title       " Show the filename in the window titlebar
    set showcmd     " Show the (partial) command as it’s being typed
    "set statusline=%<%F%h%m%r[%{&fileencoding?&fileencoding:&encoding}]%=\[%B\]\%l,%c%V\ %P

    syntax enable
    if has('gui_running')
        let g:solarized_termcolors=256
        set background=dark
        colorscheme solarized
        " colorscheme monokai
    else
        colorscheme monokai
    endif

    set fdm=syntax " folds are defined by syntax highlighting
    set scrolloff=3 " Start scrolling three lines before the horizontal window border
"

" GUI menu settings
if has("gui_running")
    set go+=m  " hide menu bar from guioptions
    set go-=T  " hide toolbar from guioptions

    set lines=60 " set page size
    let &columns=100+&numberwidth " since line number is on, add numberwidth to 100.

    menu C&ustom.VIM\ &Note :e ~/Dropbox/tools/vim/vim.md<CR>
    menu C&ustom.-sep1- <Nop>
    menu C&ustom.MYVIMRC        :e $MYVIMRC<CR>
    " menu C&ustom.-sep2- <Nop>
endif




" ----------------------------------------------------------------------------
" MAP KEY
" ----------------------------------------------------------------------------
" map mode :
"     n* : normal mode
"     v* : visual and selected mode
"     o* : operator pending mode
"     i* : insert mode
"     c* : command line mode
"     *! : map! = imap & cmap
"     <None>* : map = nmap & vmap & omap
"
" map operation:
"     *map     : add a mapping, recursively
"     *noremap : non-recursive mapping
"     *unmap   : delete a map
"     *mapclear: clear all key map in given mode
"
"    map    noremap    unmap    mapclear
"   nmap   nnoremap   nunmap   nmapclear
"   vmap   vnoremap   vunmap   vmapclear
"   imap   inoremap   iunmap   imapclear
"   cmap   cnoremap   cunmap   cmapclear
" ----------------------------------------------------------------------------
" set F2 as save
map <F2> :w<CR>
imap <F2> <ESC>:w<CR>li
" set F3 as delete buffer (not tab/window)
map <F3> :bd<CR>
imap <F3> <ESC>:bd<CR>li
" set F4 as save and quit
map <F4> :wq<CR>
imap <F4> <ESC>:wq<CR>li

" set <F5> to refresh vimrc
map <F5> :so $MYVIMRC<CR>
imap <F5> <ESC>:so $MYVIMRC<CR>li

map <F7> :!python %<CR>
imap <F7> <ESC>:w<CR>:!python %<CR>

" set <F10> to retab
map <F10> :retab<CR>
imap <F10> <ESC>:retab<CR>li

" CTRL-A is Select all
noremap <C-A> gggH<C-O>G
inoremap <C-A> <C-O>gg<C-O>gH<C-O>G
cnoremap <C-A> <C-C>gggH<C-O>G
onoremap <C-A> <C-C>gggH<C-O>G
snoremap <C-A> <C-C>gggH<C-O>G
xnoremap <C-A> <C-C>ggVG

" Tab manipulation
nmap <C-S-tab> :tabprevious<cr>
map  <C-S-tab> :tabprevious<cr>
imap <C-S-tab> <ESC>:tabprevious<cr>i
nmap <C-tab> :tabnext<cr>
map  <C-tab> :tabnext<cr>
imap <C-tab> <ESC>:tabnext<cr>i
nmap <C-t> :tabnew<cr>
map  <C-t> :tabnew<cr>
imap <C-t> <ESC>:tabnew<cr>i

" Strip trailing whitespace (,ss)
function! FormatCleanup()
    " Strip whitespaces
    let save_cursor = getpos(".")
    let old_query = getreg('/')
    :%s/\s\+$//e
    call setpos('.', save_cursor)
    call setreg('/', old_query)

    " other clean up
    :retab
    :%s/\r//ge   " replace DOS line-end characters to UNIX line-end
endfunction
noremap <leader>ss :call FormatCleanup()<CR>

