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

    " file explorer
    Plug 'kyazdani42/nvim-web-devicons' " for file icons
    Plug 'kyazdani42/nvim-tree.lua'

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

    " Syntax highlighting
    Plug 'PProvost/vim-ps1'
    " tree-sitter
    Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
    Plug 'nvim-treesitter/playground'
    Plug 'JoosepAlviste/nvim-ts-context-commentstring' " comment based on the cursor location (require treesitter)

    " LSP
    Plug 'neovim/nvim-lspconfig'
    Plug 'kabouzeid/nvim-lspinstall'
"    Plug 'anott03/nvim-lspinstall'

    " colorscheme
    Plug 'tomasiser/vim-code-dark' " Nice colorscheme based on Visual Studio dark
    Plug 'flazz/vim-colorschemes' " one stop shop for vim colorschemes

    " debugger
    Plug 'puremourning/vimspector'

    " auto complete
    Plug 'neoclide/coc.nvim', {'branch': 'release'}
    " Plug 'hrsh7th/nvim-compe'
    " Plug 'nvim-lua/completion-nvim'

    " colorizer 
    Plug 'norcalli/nvim-colorizer.lua'

    " show indentation guides to all lines (including empty lines)
    Plug 'lukas-reineke/indent-blankline.nvim', {'branch': 'lua'} " only use lua branch before nvim0.5 is out
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
    set nowritebackup
    set noswapfile
    set noundofile

    " settings coc recommend to have
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
" set F2 as save
map <F2> :w<CR>
imap <F2> <ESC>:w<CR>li

" CTRL-A is Select all
noremap <C-A> gggH<C-O>G
inoremap <C-A> <C-O>gg<C-O>gH<C-O>G
cnoremap <C-A> <C-C>gggH<C-O>G
onoremap <C-A> <C-C>gggH<C-O>G
snoremap <C-A> <C-C>gggH<C-O>G
xnoremap <C-A> <C-C>ggVG



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
map <leader>tf :TagbarForceUpdate<CR>
map <leader>tt :TagbarToggle<CR>

" ------------------------------------------------------------------------------
" CoC
" ------------------------------------------------------------------------------
" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
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
nmap <A-1> <Plug>lightline#bufferline#go(1)
nmap <A-2> <Plug>lightline#bufferline#go(2)
nmap <A-3> <Plug>lightline#bufferline#go(3)
nmap <A-4> <Plug>lightline#bufferline#go(4)
nmap <A-5> <Plug>lightline#bufferline#go(5)
nmap <A-6> <Plug>lightline#bufferline#go(6)
nmap <A-7> <Plug>lightline#bufferline#go(7)
nmap <A-8> <Plug>lightline#bufferline#go(8)
nmap <A-9> <Plug>lightline#bufferline#go(9)
nmap <A-0> <Plug>lightline#bufferline#go(10)
" mappings to delete buffers by their oridinal number
nmap <leader>d1 <Plug>lightline#bufferline#delete(1)
nmap <leader>d2 <Plug>lightline#bufferline#delete(2)
nmap <leader>d3 <Plug>lightline#bufferline#delete(3)
nmap <leader>d4 <Plug>lightline#bufferline#delete(4)
nmap <leader>d5 <Plug>lightline#bufferline#delete(5)
nmap <leader>d6 <Plug>lightline#bufferline#delete(6)
nmap <leader>d7 <Plug>lightline#bufferline#delete(7)
nmap <leader>d8 <Plug>lightline#bufferline#delete(8)
nmap <leader>d9 <Plug>lightline#bufferline#delete(9)
nmap <leader>d0 <Plug>lightline#bufferline#delete(10)

"-------------------------------------------------------------------
" Tree-Sitter config
"-------------------------------------------------------------------
:lua << EOF
    require'nvim-treesitter.configs'.setup { 
        highlight = { enable = true }, 
        playground = {
            enable = true,
            disable = {},
            updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
            persist_queries = false, -- Whether the query persists across vim sessions
            keybindings = {
                toggle_query_editor = 'o',
                toggle_hl_groups = 'i',
                toggle_injected_languages = 't',
                toggle_anonymous_nodes = 'a',
                toggle_language_display = 'I',
                focus_language = 'f',
                unfocus_language = 'F',
                update = 'R',
                goto_node = '<cr>',
                show_help = '?',
            },
        },
        query_linter = {
            enable = true,
            use_virtual_text = true,
            lint_events = {"BufWrite", "CursorHold"},
        },
    }
EOF

" -------------------------------------------------------------------
" LSP config
" -------------------------------------------------------------------
:lua <<EOF
    local nvim_lsp = require('lspconfig')
    local on_attach = function(client, bufnr)
        require('completion').on_attach()

        local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
        local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

        buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

        -- Mappings.
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
            buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.range_formatting()<CR>", opts)
        end

        -- Set autocommands conditional on server_capabilities
        if client.resolved_capabilities.document_highlight then
            vim.api.nvim_exec([[
                hi LspReferenceRead cterm=bold ctermbg=red guibg=LightYellow
                hi LspReferenceText cterm=bold ctermbg=red guibg=LightYellow
                hi LspReferenceWrite cterm=bold ctermbg=red guibg=LightYellow
                augroup lsp_document_highlight
                    autocmd! * <buffer>
                    autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
                    autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
                augroup END
            ]], false)
        end
    end

    -- Use a loop to conveniently both setup defined servers 
    -- and map buffer local keybindings when the language server attaches
    local servers = {'clangd', 'cmake', 'gopls', 'jsonls', 'powershell_es', 'pyright', 'rust_analyzer', 'vimls'}
    for _, lsp in ipairs(servers) do
        nvim_lsp[lsp].setup {
            on_attach = on_attach,
        }
    end
EOF

" Completion-nvim
let g:completion_matching_strategy_list = ['exact', 'substring', 'fuzzy']
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" -------------------- LSP ---------------------------------


" ------------------------------------------------------------------------------
" nvim-colorizer
" ------------------------------------------------------------------------------
lua require'colorizer'.setup()

" ------------------------------------------------------------------------------
" nvim-ts-context-commentstring
" ------------------------------------------------------------------------------
:lua <<EOF
require'nvim-treesitter.configs'.setup {
    context_commentstring = {
        enable = true,
        config = {
            python = {
                style_element = '# %s',
            },
            cpp = {
                style_element = '// %s',
            },
        }
    }
}
EOF
nnoremap <leader>c <cmd>lua require('ts_context_commentstring.internal').update_commentstring()<cr>

" ------------------------------------------------------------------------------
"  nvim-compe
" ------------------------------------------------------------------------------
set completeopt=menuone,noselect
let g:compe = {}
let g:compe.enabled = v:true
let g:compe.autocomplete = v:true
let g:compe.debug = v:false
let g:compe.min_length = 1
let g:compe.preselect = 'enable'
let g:compe.throttle_time = 80
let g:compe.source_timeout = 200
let g:compe.incomplete_delay = 400
let g:compe.max_abbr_width = 100
let g:compe.max_kind_width = 100
let g:compe.max_menu_width = 100
let g:compe.documentation = v:true

let g:compe.source = {}
let g:compe.source.path = v:true
let g:compe.source.buffer = v:true
let g:compe.source.calc = v:true
let g:compe.source.nvim_lsp = v:true
let g:compe.source.nvim_lua = v:true
let g:compe.source.vsnip = v:true

inoremap <silent><expr> <C-Space> compe#complete()
inoremap <silent><expr> <CR>      compe#confirm('<CR>')
inoremap <silent><expr> <C-e>     compe#close('<C-e>')
inoremap <silent><expr> <C-f>     compe#scroll({ 'delta': +4 })
inoremap <silent><expr> <C-d>     compe#scroll({ 'delta': -4 })

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

