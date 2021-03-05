" ----------------------------------------------------------------------------
" START
" ----------------------------------------------------------------------------
set nocompatible " be iMproved,  required
filetype off     " required

let os=substitute(system('uname'), '\n', '', '')
let isNeovim=has('nvim')
let isNvimQt=has('nvim') && exists('g:GuiLoaded')

" ----------------------------------------------------------------------------
" EDITING
" ----------------------------------------------------------------------------

" VIM system settings
    set clipboard=unnamed   " Use the OS clipboard by default
    set clipboard+=unnamedplus " neovim use this to use the OS clipboard
    set wildmenu            " Enhance command-line completion
    set wildmode=longest,list,full
    set backspace=indent,eol,start " Allow backspace in insert mode
    set ttyfast             " Optimize for fast terminal connections
    set gdefault            " Add the g flag to search/replace by default
    set encoding=utf-8 nobomb " Use UTF-8 without BOM
    let mapleader=","       " Change mapleader
    set nobackup
    set noswapfile
    set noundofile
"

" Editting
    set expandtab       " replace tab with spaces
    set autoindent
    set tabstop=4
    set shiftwidth=4    " # of spaces to use for each step of (auto)indent
    set softtabstop=4   " # of spaces that a tab counts for while performing editing
    set textwidth=100   " maximum width of a line. Longer line will be broken into lines.
    set colorcolumn=+1,+21,-19  " highlight column after textwidth

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
    autocmd BufNewFile,BufRead *.ps1 setlocal filetype=ps1
endif

" ----------------------------------------------------------------------------
" GUI
" ----------------------------------------------------------------------------
" Termimal UI
if isNvimQt == 0
    set guifont=Consolas:h10,Courier_New:h10
else
    GuiFont! Consolas:h11
endif
    set number      " Enable line numbers
    set cursorline  " Highlight current line
    set relativenumber " Use relative line numbers
    set list listchars=tab:>-,trail:-   " (list + listchars) shows “invisible” characters
    set showmatch   " show matching brackets/braces/parantheses

    set laststatus=2 " Always show status line
    set mouse=a     " Enable mouse in all modes
    set errorbells
    set visualbell  " silence the bell, use a flash instead
    set nostartofline " Don’t reset cursor to start of line when moving around.
    set ruler       " Show the cursor position
    set wrap
    set shortmess=atI " Don’t show the intro message when starting Vim
    set showmode    " Show the current mode
    set title       " Show the filename in the window titlebar
    set showcmd     " Show the (partial) command as it’s being typed
    set scrolloff=3 " minimal number of screen lines to keep above and below the cursor


    syntax enable
"

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
imap <F3> <ESC>:bd<CR>
" set F4 as save and quit
map <F4> :x<CR>
imap <F4> <ESC>:x<CR>

" set <F5> to refresh vimrc
map <F5> :so $MYVIMRC<CR>
imap <F5> <ESC>:so $MYVIMRC<CR>li
function! OpenRealVimrc()
    if filereadable("T:/github/dotfiles/.vimrc")
       :e T:/github/dotfiles/.vimrc
    else
       :e $HOME/Desktop/GitHub/dotfiles/.vimrc
    endif
endfunction
map <F6> :call OpenRealVimrc()<CR>
imap <F6> <ESC>:call OpenRealVimrc()<CR>

" <F7>: run current python file
map <F7> :!python %<CR>
imap <F7> <ESC>:w<CR>:!python %<CR>

map <F10> :retab<CR>
imap <F10> <ESC>:retab<CR>li
map <F11> :TagbarForceUpdate<CR>
imap <F11> <ESC>:TagbarForceUpdate<CR>li
map <F12> :TagbarToggle<CR>
imap <F12> <ESC>:TagbarToggle<CR>li

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

nnoremap <C-p> :FZF<cr>

" " Copy to clipboard
vnoremap  <leader>y  "+y
nnoremap  <leader>Y  "+yg_
nnoremap  <leader>y  "+y
nnoremap  <leader>yy  "+yy

" " Paste from clipboard
nnoremap <leader>p "+p
nnoremap <leader>P "+P
vnoremap <leader>p "+p
vnoremap <leader>P "+P

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

" -----------------------------------------------------------------------------
" vim-plug plugins
" -----------------------------------------------------------------------------
call plug#begin(stdpath('data') . '/plugged')
    " Make sure you use single quotes

    Plug 'preservim/nerdtree', { 'on': 'NERDTreeToggle' } " file system explorer
    Plug 'vim-airline/vim-airline'    " status bar
    Plug 'vim-airline/vim-airline-themes'
    Plug 'preservim/tagbar'   " tag list

    " Fuzzy file finder
    Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
    Plug 'junegunn/fzf.vim'

    " Syntax highlight
    Plug 'PProvost/vim-ps1'

    " colorscheme
    Plug 'tomasiser/vim-code-dark' " Nice colorscheme based on Visual Studio dark
    Plug 'flazz/vim-colorschemes' " one stop shop for vim colorschemes
call plug#end()            " required
" Brief help
" :PlugInstall      - installs plugins
" :PlugUpdate       - install or update plugins
" :PlugUpgrade      - upgrade vim-plug itself
" :PlugStatus       - check the status of plugins
" :PlugClean        - remove unlisted plugins
" see :h vundle for more details or wiki for FAQ


" ------------------------------------------------------------------------------
" Plugin configurations
" ------------------------------------------------------------------------------

" colorscheme must be set after plug configuration
colorscheme codedark

"""  Tagbar
" to display tags ordered by heading on markdown files
let g:tagbar_type_markdown = {
  \ 'ctagstype' : 'markdown',
  \ 'kinds'     : [
  \     'c:chapter:0:1',
  \     's:section:0:1', 'S:subsection:0:1', 't:subsubsection:0:1',
  \     'T:l4subsection:0:1', 'u:l5subsection:0:1',
  \ ],
  \ 'sro'           : '""',
  \ 'kind2scope'    : {
  \     'c' : 'chapter', 's' : 'section', 'S' : 'subsection', 't' : 'subsubsection', 'T' : 'l4subsection',
  \ },
  \ 'scope2kind'    : {
  \     'chapter' : 'c', 'section' : 's', 'subsection' : 'S', 'subsubsection' : 't', 'l4subsection' : 'T',
  \ },
\ }


" --------------------------------------------------------------
""" FZF
" --------------------------------------------------------------

" actions to take when press keys in search
let g:fzf_action = { 'ctrl-t': 'tab split', 'ctrl-x': 'split',  'ctrl-v': 'vsplit' }

map <leader>f :Files<CR>
map <leader>b :Buffers<CR>

" customize :Files command to show preview with `bat`
command! -bang -nargs=? -complete=dir Files call fzf#vim#files(<q-args>, {'options': ['--preview', 'bat --color=always --style=numbers {}']}, <bang>0)


