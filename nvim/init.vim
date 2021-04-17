" ----------------------------------------------------------------------------
" START
" ----------------------------------------------------------------------------
"  TODO:
"   - move neovim lua config to its own folder.
"   - split neovim config
"   - debugger switch to nvim-dap
set nocompatible " be iMproved,  required
filetype off     " required

let isNeovim=has('nvim')
let isNvimQt=has('nvim') && exists('g:GuiLoaded')

"---- vim-plug setup  ----
if isNeovim==1
    let plugpath=stdpath('data') . '/plugged'
    let vimplug_exists=stdpath('data') . '/site/autoload/plug.vim'
else
    let plugpath=expand('~/.config/vim-data/plugged')
    let vimplug_exists=expand('~/.config/vim-data/autoload/plug.vim')
endif

if !filereadable(vimplug_exists)
    silent exec "!curl -fLo " . shellescape(vimplug_exists) . " --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
    let g:not_finish_vimplug = "yes"
    autocmd VimEnter * PlugInstall
endif
"-------- end vim-plug setup ----

" -----------------------------------------------------------------------------
" vim-plug plugins
" -----------------------------------------------------------------------------
call plug#begin(plugpath)
    " Make sure you use single quotes

    " file explorer
    Plug 'kyazdani42/nvim-web-devicons' " for file icons
    "Plug 'kyazdani42/nvim-tree.lua', { 'on': 'NvimTreeToggle' }
    Plug 'preservim/nerdtree' 
    Plug 'preservim/nerdcommenter'
    Plug 'preservim/tagbar', { 'on': 'TagbarToggle' }   " tag list
    Plug 'tpope/vim-fugitive'   " git plugin

    Plug 'itchyny/lightline.vim' " faster statusline colorschemes
    Plug 'mengelbrecht/lightline-bufferline'  " bufferline solorschemes

    " Fuzzy file finder
    Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
    Plug 'junegunn/fzf.vim'
    " telescope
    Plug 'nvim-lua/popup.nvim'
    Plug 'nvim-lua/plenary.nvim'    " shared functions by the author, required if installing other plugins from the same author
    Plug 'nvim-telescope/telescope.nvim'
    Plug 'nvim-telescope/telescope-vimspector.nvim'

    " Syntax highlighting
    Plug 'PProvost/vim-ps1'

    " tree-sitter
    Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
    Plug 'nvim-treesitter/playground'

    " LSP
    Plug 'neovim/nvim-lspconfig'
    "Plug 'kabouzeid/nvim-lspinstall'   " this config runs cmd line as in linux shell. Not work on Windows
    "Plug 'anott03/nvim-lspinstall'     " this plug has little LSP server I want
    Plug 'mattn/vim-lsp-settings'       " this works great. Just :LspInstallServer after open a file, it will install for current file
    Plug 'onsails/lspkind-nvim'

    " colorscheme
    Plug 'tomasiser/vim-code-dark' " Nice colorscheme based on Visual Studio dark
    Plug 'liuchengxu/space-vim-theme'
    Plug 'flazz/vim-colorschemes' " one stop shop for vim colorschemes
    Plug 'colepeters/spacemacs-theme.vim'
    Plug 'sainnhe/gruvbox-material'
    Plug 'phanviet/vim-monokai-pro'
    Plug 'dracula/vim', { 'as': 'dracula' }

    " debugger
    Plug 'puremourning/vimspector' " TODO: change to nvim-dap
    " Plug 'mfussenegger/nvim-dap'
    Plug 'szw/vim-maximizer' " Maximizes and restores the current window in Vim.

    " auto complete
    Plug 'hrsh7th/nvim-compe'
    " Plug 'neoclide/coc.nvim', {'branch': 'release'}
    " Plug 'nvim-lua/completion-nvim'

    " colorizer
    Plug 'norcalli/nvim-colorizer.lua'

    " show indentation guides to all lines (including empty lines)
    Plug 'lukas-reineke/indent-blankline.nvim', {'branch': 'lua'} " only use lua branch before nvim0.5 is out

    " display the key bindings following your currently entered incomplete command
    Plug 'liuchengxu/vim-which-key', { 'on': ['WhichKey', 'WhichKey!'] }
    Plug 'AckslD/nvim-whichkey-setup.lua'

call plug#end()            " required
" Brief help
" :PlugInstall      - installs plugins
" :PlugUpdate       - install or update plugins
" :PlugUpgrade      - upgrade vim-plug itself
" :PlugStatus       - check the status of plugins
" :PlugClean        - remove unlisted plugins
" see :h vundle for more details or wiki for FAQ

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
    set nobackup
    set nowritebackup
    set noswapfile
    set noundofile

    "" settings coc recommend to have
    set hidden
    set cmdheight=2
    set updatetime=50
    set shortmess+=c

    au FocusGained * :checktime  " when regain focus, check if any buffer were changed outside.
    set autoread    " auto reload a file if it is detected to have been changed outside.
"

" Editting
    set expandtab       " replace tab with spaces
    set autoindent
    set tabstop=4
    set shiftwidth=4    " # of spaces to use for each step of (auto)indent
    set softtabstop=4   " # of spaces that a tab counts for while performing editing
    set textwidth=100   " maximum width of a line. Longer line will be broken into lines.
    set colorcolumn=+1,+21,-19  " highlight column after textwidth

    " colorscheme must be set after plug configuration
    colorscheme dracula

    " hi ColorColumn ctermbg=lightgrey guibg=red
    hi ColorColumn guibg=red

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
    filetype plugin on
    " Treat .json files as .js
    autocmd BufNewFile,BufRead *.json   setfiletype json syntax=javascript
    " Treat .md files as Markdown
    autocmd BufNewFile,BufRead *.md     setlocal filetype=markdown
    autocmd BufNewFile,BufRead *.ps1    setlocal filetype=ps1
endif

" ----------------------------------------------------------------------------
" GUI
" ----------------------------------------------------------------------------
" Termimal UI
"
if isNvimQt == 0
    set guifont=Consolas:h11,Courier_New:h10
endif
    set number      " Enable line numbers
    set cursorline  " Highlight current line
    set relativenumber " Use relative line numbers
    set list listchars=tab:>-,trail:-   " (list + listchars) shows “invisible” characters
    set showmatch   " show matching brackets/braces/parantheses

    set showtabline=2   " Always show tabline
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

    if has('termguicolors')
        " both nvim-colorizer and nvim-tree need termguicolors
        set termguicolors " this variable must be enabled for colors to be applied properly
    endif

    syntax enable
"
let g:loaded_python_provider = 0 " disable python2 provider
let g:loaded_ruby_provider = 0
let g:loaded_perl_provider = 0

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

"------------------------------------------------------------------------------
" vim-which-key
" -------------------------------------------------------------------------------
let mapleader="\<Space>"       " Change mapleader
let maplocalleader=","  " Change maplocalleader
set timeoutlen=500
nnoremap <silent> <leader>      :<c-u>WhichKey '<Space>'<CR>
nnoremap <silent> <localleader> :<c-u>WhichKey ','<CR>
autocmd! User vim-which-key call which_key#register('<Space>', 'g:which_key_map')

" set F2 as save
map <F2> :up<CR>
imap <F2> <C-O>:up<CR>
" <F3> is the used by Maximizer by default

let g:which_key_map = {}  " define vim-which-key prefix dictionary
let g:which_key_map.b = {'name': 'buffer edit' }
let g:which_key_map.c = {'name': 'NerdCommenter' }
let g:which_key_map.f = {'name': 'file edit' }
let g:which_key_map.w = {'name': 'window edit' }

noremap <silent> <leader>ba gggH<C-O>G
let g:which_key_map.b.a = 'select all'

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
noremap <leader>bf :call FormatCleanup()<CR>
let g:which_key_map.b.f = 'format buffer'

noremap <silent> <leader>fv :e $MYVIMRC<cr>
let g:which_key_map.f.v = 'open $MYVIMRC'

noremap <silent> <leader>fr :so $MYVIMRC<cr>
let g:which_key_map.f.r = 'reload $MYVIMRC'



" ------------------------------------------------------------------------------
" Plugin configurations
" ------------------------------------------------------------------------------
let g:indent_blankline_show_first_indent_level = v:false
let g:indent_blankline_user_treesitter = v:true

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
map <leader>tf :TagbarForceUpdate<CR>
map <leader>tt :TagbarToggle<CR>


" --------------------------------------------------------------
""" FZF
" --------------------------------------------------------------

" actions to take when press keys in search
let g:fzf_action = { 'ctrl-t': 'tab split', 'ctrl-x': 'split',  'ctrl-v': 'vsplit' }

" map <leader>f :Files<CR>
" map <leader>b :Buffers<CR>
nnoremap <C-p> :FZF<cr>

" customize :Files command to show preview with `bat`
command! -bang -nargs=? -complete=dir Files call fzf#vim#files(<q-args>, {'options': ['--preview', 'bat --color=always --style=numbers {}']}, <bang>0)

" --------------------------------------------------------------------
" Telescope config
" --------------------------------------------------------------------
" Find files using Telescope command-line sugar.
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>
nnoremap <leader>fk <cmd>Telescope keymaps<cr>

" --------------------------------------------------------------
" Vimspector
" --------------------------------------------------------------
let g:vimspector_install_gadgets = [ 'debugpy', 'vscode-cpptools', 'CodeLLDB' ] " VimspectorUpdate will automatically install them
" packadd! vimspector " seems only need this is we are not using a plugin manager

" let g:vimspector_enable_mappings = 'HUMAN'
" nmap <F5> <Plug>VimspectorContinue
" nmap <F3> <Plug>VimspectorStop
" nmap <F4> <Plug>VimspectorRestart
" nmap <F6> <Plug>VimspectorPause
" nmap <F9> <Plug>VimspectorToggleBreakpoint
" nmap <leader><F9> <Plug>VimspectorToogleConditionalBreakpoint
" nmap <F8> <Plug>VimspectorAddFunctionBreakpoint
" nmap <leader><F8> <Plug>VimspectorRunToCursor
" nmap <F10> <Plug>VimspectorStepOver
" nmap <F11> <Plug>VimspectorStepInto
" nmap <F12> <Plug>VimspectorStepOut

let g:vimspector_enable_mappings = 'VISUAL_STUDIO'
" nmap <F5> <Plug>VimspectorContinue
" nmap <S-F5> <Plug>VimspectorStop
" nmap <C-S-F5> <Plug>VimspectorRestart
" nmap <F6> <Plug>VimspectorPause
" nmap <F9> <Plug>VimspectorToggleBreakpoint
" nmap <S-F9> <Plug>VimspectorAddFunctionBreakpoint
" nmap <F10> <Plug>VimspectorStepOver
" nmap <F11> <Plug>VimspectorStepInto
" nmap <S-F11> <Plug>VimspectorStepOut

" mnemonic 'di' = 'debug inspect' (pick your own, if you prefer!)
" for normal mode - the word under the cursor
nmap <Leader>di <Plug>VimspectorBalloonEval
" for visual mode, the visually selected text
xmap <Leader>di <Plug>VimspectorBalloonEval

" -----------------------------------------------------------------
" lightline config
" -----------------------------------------------------------------
"  add gitbranch to left statusline, buffer list to tabline
let g:lightline = {
    \   'active': {
    \     'left':[ ['mode', 'paste'],  ['gitbranch', 'readonly', 'filename', 'modified'] ],
    \   },
    \   'component_expand': { 'buffers': 'lightline#bufferline#buffers' },
    \   'component_type': { 'buffers': 'tabsel' },
    \   'component_function': { 'gitbranch': 'fugitive#head' },
    \   'tabline': { 'left': [['buffers']], 'right': [['close']] }
    \ }

let g:lightline.colorscheme = 'darcula'
" show bufferline index number
let g:lightline#bufferline#show_number=2
let g:lightline#bufferline#filename_modifier = ':t' " hide filepath, only show filename
" with neovim 'tablineat' feature, this allow mouse to click bufferline to switch
if has('tablineat')
    let g:lightline.component_raw = {'buffers': 1}
    let g:lightline#bufferline#clickable=1
endif

autocmd BufWritePost,TextChanged,TextChangedI * call lightline#update()

" hotkey to switch to buffer using their ordinal number in the bufferline
nmap <leader>bg1 <Plug>lightline#bufferline#go(1)
nmap <leader>bg2 <Plug>lightline#bufferline#go(2)
nmap <leader>bg3 <Plug>lightline#bufferline#go(3)
nmap <leader>bg4 <Plug>lightline#bufferline#go(4)
nmap <leader>bg5 <Plug>lightline#bufferline#go(5)
nmap <leader>bg6 <Plug>lightline#bufferline#go(6)
nmap <leader>bg7 <Plug>lightline#bufferline#go(7)
nmap <leader>bg8 <Plug>lightline#bufferline#go(8)
nmap <leader>bg9 <Plug>lightline#bufferline#go(9)
nmap <leader>bg0 <Plug>lightline#bufferline#go(10)
" mappings to delete buffers by their oridinal number
nmap <leader>bd1 <Plug>lightline#bufferline#delete(1)
nmap <leader>bd2 <Plug>lightline#bufferline#delete(2)
nmap <leader>bd3 <Plug>lightline#bufferline#delete(3)
nmap <leader>bd4 <Plug>lightline#bufferline#delete(4)
nmap <leader>bd5 <Plug>lightline#bufferline#delete(5)
nmap <leader>bd6 <Plug>lightline#bufferline#delete(6)
nmap <leader>bd7 <Plug>lightline#bufferline#delete(7)
nmap <leader>bd8 <Plug>lightline#bufferline#delete(8)
nmap <leader>bd9 <Plug>lightline#bufferline#delete(9)
nmap <leader>bd0 <Plug>lightline#bufferline#delete(10)

"-------------------------------------------------------------------
" Tree-Sitter config
"-------------------------------------------------------------------
lua require('tree-sitter-config')

" -------------------------------------------------------------------
" LSP config
" -------------------------------------------------------------------
lua require('nvim-lsp-config')

" ------------------------------------------------------------------------------
" nvim-colorizer
" ------------------------------------------------------------------------------
lua require'colorizer'.setup()

" ------------------------------------------------------------------------------
"  nvim-compe
" ------------------------------------------------------------------------------
if has_key(plugs, "nvim-compe")
    set completeopt=menuone,noselect
    lua require('nvim-compe-config')

    inoremap <silent><expr> <C-Space> compe#complete()
    inoremap <silent><expr> <CR>      compe#confirm('<CR>')
    inoremap <silent><expr> <C-e>     compe#close('<C-e>')
    inoremap <silent><expr> <C-f>     compe#scroll({ 'delta': +4 })
    inoremap <silent><expr> <C-d>     compe#scroll({ 'delta': -4 })
endif

" ------------------------------------------------------------------------------
" NERDTree
" ------------------------------------------------------------------------------

let g:which_key_map.n = {'name': 'NERDTree' }
nnoremap <leader>nt :NERDTreeToggle<CR>
nnoremap <leader>nn :NERDTreeFocus<CR>
nnoremap <leader>nf :NERDTreeFind<CR>
" NERDTreeFind will show directory on current file



"------------------------------------------------------------------------------
" vim-maximizer
" -------------------------------------------------------------------------------
" nnoremap <silent><F3> :MaximizerToggle<CR>
" vnoremap <silent><F3> :MaximizerToggle<CR>gv
" inoremap <silent><F3> <C-o>:MaximizerToggle<CR>
" let g:maximizer_set_default_mapping = 1
" let g:maximizer_set_mapping_with_bang = 0
" let g:maximizer_default_mapping_key = '<F3>'


"------------------------------------------------------------------------------
" indent-blankline
" -------------------------------------------------------------------------------
let g:indent_blankline_char_list = ['¦', '¦', '┆', '┊']


