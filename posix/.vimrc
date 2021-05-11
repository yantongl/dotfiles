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

    " file explorer
    Plug 'kyazdani42/nvim-web-devicons' " for file icons
    Plug 'kyazdani42/nvim-tree.lua'

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
    set hidden              " coc says TextEdit might fail if hidden is not set
    set cmdheight=2
    set updatetime=50
    set shortmess+=c
    " Always show the signcolumn, otherwise it would shift the text each time
    " diagnostics appear/become resolved.
    if has("patch-8.1.1564")
        " Recently vim can merge signcolumn and number column into one
        set signcolumn=number
    else
        set signcolumn=yes
    endif

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
    colorscheme gruvbox 

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

    if has('termguicolors')
        " both nvim-colorizer and nvim-tree need termguicolors
        set termguicolors " this variable must be enabled for colors to be applied properly
    endif


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
map <F2> :w<CR>
imap <F2> <C-O>:w<CR>
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

" Using lua functions
" nnoremap <leader>ff <cmd>lua require('telescope.builtin').find_files()<cr>
" nnoremap <leader>fg <cmd>lua require('telescope.builtin').live_grep()<cr>
" nnoremap <leader>fb <cmd>lua require('telescope.builtin').buffers()<cr>
" nnoremap <leader>fh <cmd>lua require('telescope.builtin').help_tags()<cr>

:lua <<EOF
--  require('telescope').setup() { }
--  require('telescope').load_extension('dap')
--  require('telescope').load_extension('vimspector')
EOF

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
" nvim-tree
" ------------------------------------------------------------------------------
"let g:nvim_tree_side = 'right' | 'left' "left by default
let g:nvim_tree_width = 40 "30 by default
let g:nvim_tree_ignore = [ '.git', 'node_modules', '.cache' ] "empty by default
let g:nvim_tree_auto_open = 0 "0 by default, opens the tree when typing `vim $DIR` or `vim`
let g:nvim_tree_auto_close = 1 "0 by default, closes the tree when it's the last window
" let g:nvim_tree_auto_ignore_ft = {'startify', 'dashboard'} "empty by default, don't auto open tree on specific filetypes.
"let g:nvim_tree_quit_on_open = 1 "0 by default, closes the tree when you open a file
let g:nvim_tree_follow = 1 "0 by default, this option allows the cursor to be updated when entering a buffer
let g:nvim_tree_indent_markers = 1 "0 by default, this option shows indent markers when folders are open
let g:nvim_tree_hide_dotfiles = 1 "0 by default, this option hides files and folders starting with a dot `.`
let g:nvim_tree_git_hl = 1 "0 by default, will enable file highlight for git attributes (can be used without the icons).
let g:nvim_tree_root_folder_modifier = ':~' "This is the default. See :help filename-modifiers for more options
let g:nvim_tree_tab_open = 1 "0 by default, will open the tree when entering a new tab and the tree was previously open
let g:nvim_tree_width_allow_resize  = 1 "0 by default, will not resize the tree when opening a file
" let g:nvim_tree_disable_netrw = 0 "1 by default, disables netrw
" let g:nvim_tree_hijack_netrw = 0 "1 by default, prevents netrw from automatically opening when opening directories (but lets you keep its other utilities)
" let g:nvim_tree_add_trailing = 1 "0 by default, append a trailing slash to folder names
let g:nvim_tree_show_icons = { 'git': 1, 'folders': 1, 'files': 1, }
"If 0, do not show the icons for one of 'git' 'folder' and 'files'
"1 by default, notice that if 'files' is 1, it will only display
"if nvim-web-devicons is installed and on your runtimepath

" default will show icon by default if no icon is provided
" default shows no icon by default
let g:nvim_tree_icons = {
    \ 'default': '',
    \ 'symlink': '',
    \ 'git': {
    \   'unstaged': "✗", 'staged': "✓", 'unmerged': "", 'renamed': "➜",  'untracked': "★"  },
    \ 'folder': {
    \   'default': "", 'open': "", 'empty': "", 'empty_open': "", 'symlink': "", 'symlink_open': ""  }
    \ }

nnoremap <leader>tt :NvimTreeToggle<CR>
nnoremap <leader>tr :NvimTreeRefresh<CR>
nnoremap <leader>tn :NvimTreeFindFile<CR>
" NvimTreeOpen and NvimTreeClose are also available if you need them
" NvimTreeFindFile will open tree view and focus on it

"Open file in current buffer or in split with FzF like bindings (<CR>, <C-v>, <C-x>, <C-t>)

" a list of groups can be found at `:help nvim_tree_highlight`
highlight NvimTreeFolderIcon guibg=blue

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



" ------------------------------------------------------------------------------
" CoC
" ------------------------------------------------------------------------------
" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
" {{{
if has_key(plugs, "coc.nvim")
    inoremap <silent><expr> <TAB>
        \ pumvisible() ? "\<C-n>" :
        \ <SID>check_back_space() ? "\<TAB>" :
        \ coc#refresh()
    inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

    function! s:check_back_space() abort
        let col = col('.') - 1
        return !col || getline('.')[col - 1]  =~# '\s'
    endfunction

    " Use <c-space> to trigger completion.
    if has('nvim')
        inoremap <silent><expr> <c-space> coc#refresh()
    else
        inoremap <silent><expr> <c-@> coc#refresh()
    endif

    " Make <CR> auto-select the first completion item and notify coc.nvim to
    " format on enter, <cr> could be remapped by other vim plugin
    inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                                  \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

    " Use `[g` and `]g` to navigate diagnostics
    " Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
    nmap <silent> [g <Plug>(coc-diagnostic-prev)
    nmap <silent> ]g <Plug>(coc-diagnostic-next)

    " GoTo code navigation.
    nmap <silent> gd <Plug>(coc-definition)
    nmap <silent> gy <Plug>(coc-type-definition)
    nmap <silent> gi <Plug>(coc-implementation)
    nmap <silent> gr <Plug>(coc-references)

    " Use K to show documentation in preview window.
    nnoremap <silent> K :call <SID>show_documentation()<CR>

    function! s:show_documentation()
        if (index(['vim','help'], &filetype) >= 0)
            execute 'h '.expand('<cword>')
        elseif (coc#rpc#ready())
            call CocActionAsync('doHover')
        else
            execute '!' . &keywordprg . " " . expand('<cword>')
        endif
    endfunction

    " Highlight the symbol and its references when holding the cursor.
    autocmd CursorHold * silent call CocActionAsync('highlight')

    " Symbol renaming.
    nmap <leader>rn <Plug>(coc-rename)

    " Formatting selected code.
    xmap <leader>f  <Plug>(coc-format-selected)
    nmap <leader>f  <Plug>(coc-format-selected)

    augroup mygroup
        autocmd!
        " Setup formatexpr specified filetype(s).
        autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
        " Update signature help on jump placeholder.
        autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
    augroup end

    " Applying codeAction to the selected region.
    " Example: `<leader>aap` for current paragraph
    xmap <leader>a  <Plug>(coc-codeaction-selected)
    nmap <leader>a  <Plug>(coc-codeaction-selected)

    " Remap keys for applying codeAction to the current buffer.
    nmap <leader>ac  <Plug>(coc-codeaction)
    " Apply AutoFix to problem on the current line.
    nmap <leader>qf  <Plug>(coc-fix-current)

    " Map function and class text objects
    " NOTE: Requires 'textDocument.documentSymbol' support from the language server.
    xmap if <Plug>(coc-funcobj-i)
    omap if <Plug>(coc-funcobj-i)
    xmap af <Plug>(coc-funcobj-a)
    omap af <Plug>(coc-funcobj-a)
    xmap ic <Plug>(coc-classobj-i)
    omap ic <Plug>(coc-classobj-i)
    xmap ac <Plug>(coc-classobj-a)
    omap ac <Plug>(coc-classobj-a)

    " Remap <C-f> and <C-b> for scroll float windows/popups.
    if has('nvim-0.4.0') || has('patch-8.2.0750')
        nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
        nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
        inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
        inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
        vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
        vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
    endif

    " Use CTRL-S for selections ranges.
    " Requires 'textDocument/selectionRange' support of language server.
    nmap <silent> <C-s> <Plug>(coc-range-select)
    xmap <silent> <C-s> <Plug>(coc-range-select)

    " Add `:Format` command to format current buffer.
    command! -nargs=0 Format :call CocAction('format')

    " Add `:Fold` command to fold current buffer.
    command! -nargs=? Fold :call     CocAction('fold', <f-args>)

    " Add `:OR` command for organize imports of the current buffer.
    command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

    " Add (Neo)Vim's native statusline support.
    " NOTE: Please see `:h coc-status` for integrations with external plugins that
    " provide custom statusline: lightline.vim, vim-airline.
    set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

    " Mappings for CoCList
    " Show all diagnostics.
    nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
    " Manage extensions.
    nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
    " Show commands.
    nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
    " Find symbol of current document.
    nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
    " Search workspace symbols.
    nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
    " Do default action for next item.
    nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
    " Do default action for previous item.
    nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
    " Resume latest coc list.
    nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>
endif
" }}}

