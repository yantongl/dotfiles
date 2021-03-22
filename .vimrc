" ----------------------------------------------------------------------------
" START
" ----------------------------------------------------------------------------
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
  if !executable('curl')
    echoerr "You have to install curl or first install vim-plug yourself!"
    execute "q!"
  endif
  echo "Installing Vim-Plug..."
  echo ""
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

    Plug 'preservim/nerdtree', { 'on': 'NERDTreeToggle' } " file system explorer
    Plug 'preservim/tagbar', { 'on': 'TagbarToggle' }   " tag list
    Plug 'tpope/vim-fugitive'   " git plugin

    " Plug 'vim-airline/vim-airline'    " status bar
    " Plug 'vim-airline/vim-airline-themes'
    Plug 'itchyny/lightline.vim' " faster statusline colorschemes
    Plug 'mengelbrecht/lightline-bufferline'  " bufferline solorschemes

    " Fuzzy file finder
    Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
    Plug 'junegunn/fzf.vim'

    " Syntax highlight
    Plug 'PProvost/vim-ps1'

    if has('nvim-0.5')
        Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
        Plug 'neovim/nvim-lspconfig'
        Plug 'nvim-lua/completion-nvim'

        " telescope
        Plug 'nvim-lua/popup.nvim'
        Plug 'nvim-lua/plenary.nvim'
        Plug 'nvim-telescope/telescope.nvim'
    endif

    " colorscheme
    Plug 'tomasiser/vim-code-dark' " Nice colorscheme based on Visual Studio dark
    Plug 'flazz/vim-colorschemes' " one stop shop for vim colorschemes

    Plug 'puremourning/vimspector'
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
    let mapleader=","       " Change mapleader
    set nobackup
    set noswapfile
    set noundofile

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
    colorscheme codedark

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
if exists('g:GuiLoaded')
    GuiFont! Consolas:h11
    GuiTabline 0
else
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
    e $MYVIMRC
endfunction
map <F6> :call OpenRealVimrc()<CR>
imap <F6> <ESC>:call OpenRealVimrc()<CR>

" <F7>: run current python file
"map <F7> :!python %<CR>
"imap <F7> <ESC>:w<CR>:!python %<CR>

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


" ------------------------------------------------------------------------------
" Plugin configurations
" ------------------------------------------------------------------------------

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

" map <leader>f :Files<CR>
" map <leader>b :Buffers<CR>

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

" Using lua functions
" nnoremap <leader>ff <cmd>lua require('telescope.builtin').find_files()<cr>
" nnoremap <leader>fg <cmd>lua require('telescope.builtin').live_grep()<cr>
" nnoremap <leader>fb <cmd>lua require('telescope.builtin').buffers()<cr>
" nnoremap <leader>fh <cmd>lua require('telescope.builtin').help_tags()<cr>

" --------------------------------------------------------------
" Vimspector
" --------------------------------------------------------------
let g:vimspector_enable_mappings = 'HUMAN'
let g:vimspector_install_gadgets = [ 'debugpy', 'vscode-cpptools', 'CodeLLDB' ]
packadd! vimspector

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
nmap <C-1> <Plug>lightline#bufferline#go(1)
nmap <C-2> <Plug>lightline#bufferline#go(2)
nmap <C-3> <Plug>lightline#bufferline#go(3)
nmap <C-4> <Plug>lightline#bufferline#go(4)
nmap <C-5> <Plug>lightline#bufferline#go(5)
nmap <C-6> <Plug>lightline#bufferline#go(6)
nmap <C-7> <Plug>lightline#bufferline#go(7)
nmap <C-8> <Plug>lightline#bufferline#go(8)
nmap <C-9> <Plug>lightline#bufferline#go(9)
nmap <C-0> <Plug>lightline#bufferline#go(10)
" mappings to delete buffers by their oridinal number
nmap <A-1> <Plug>lightline#bufferline#delete(1)
nmap <A-2> <Plug>lightline#bufferline#delete(2)
nmap <A-3> <Plug>lightline#bufferline#delete(3)
nmap <A-4> <Plug>lightline#bufferline#delete(4)
nmap <A-5> <Plug>lightline#bufferline#delete(5)
nmap <A-6> <Plug>lightline#bufferline#delete(6)
nmap <A-7> <Plug>lightline#bufferline#delete(7)
nmap <A-8> <Plug>lightline#bufferline#delete(8)
nmap <A-9> <Plug>lightline#bufferline#delete(9)
nmap <A-0> <Plug>lightline#bufferline#delete(10)

if has('nvim-0.5')
lua << EOF
    -------------------------------------------------------------------
    -- Tree-Sitter config
    -------------------------------------------------------------------
    require 'nvim-treesitter.install'.compilers = { "clang" }
    require'nvim-treesitter.configs'.setup { highlight = { enable = true }, }

    -------------------------------------------------------------------
    -- LSP config
    -------------------------------------------------------------------
    local nvim_lsp = require('lspconfig')

    local on_attach = function(client, bufnr)
    require('completion').on_attach()

    local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
    local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

    buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

    -- Mappings
    local opts = { noremap=true, silent=true }
    buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
    buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
    buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
    buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
    buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
    buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
    buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
    buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
    buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
    buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
    buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
    buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
    buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
    buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
    buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)

    -- Set some keybinds conditional on server capabilities
    if client.resolved_capabilities.document_formatting then
        buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
    elseif client.resolved_capabilities.document_range_formatting then
        buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
    end

    -- Set autocommands conditional on server_capabilities
    if client.resolved_capabilities.document_highlight then
        vim.api.nvim_exec([[
        :hi LspReferenceRead cterm=bold ctermbg=red guibg=LightYellow
        :hi LspReferenceText cterm=bold ctermbg=red guibg=LightYellow
        :hi LspReferenceWrite cterm=bold ctermbg=red guibg=LightYellow
        augroup lsp_document_highlight
            autocmd!
            autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
            autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
        augroup END
        ]], false)
    end
  end

  -- local servers = {'pyright', 'gopls', 'rust_analyzer'}
  local servers = {'pyright'}
  for _, lsp in ipairs(servers) do
    nvim_lsp[lsp].setup {
      on_attach = on_attach,
    }
  end
EOF

" Completion
let g:completion_matching_strategy_list = ['exact', 'substring', 'fuzzy']
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
" -------------------- LSP ---------------------------------
endif
