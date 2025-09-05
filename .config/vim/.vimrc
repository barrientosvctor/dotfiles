" ===============================================================
" Vimrc Configuration File (Working since Vim 9.1)
" ===============================================================

" Settings: {{{

set bg=dark
set number
set relativenumber
set history=1000
set ruler
set colorcolumn=80
set wrap
set cursorline

" Search
set hlsearch
set showmatch
set incsearch

" Syntax / indent / files config
syntax on
set encoding=utf-8
scriptencoding utf-8
filetype indent plugin on
set autoindent
set smartindent
set nowrap
set backspace=2
set hidden
set expandtab
set shiftwidth=4
set softtabstop=4  " Use value of shiftwidth
set smarttab       " Always use shiftwidth

" Remove backups
set noswapfile                      " it does not create swap files
set nobackup                        " it does not create backup files, use git instead!

" Other
set laststatus=2
set wildmenu
let mapleader = ","

highlight ExtraWhitespace ctermbg=1
match ExtraWhitespace /\s\+$/

if has("gui_running")
    set guioptions-=T
    set guioptions-=m
    set guifont=JetBrains\ Mono:h16
endif

" Detecting (name) as file names. https://github.com/vim/vim/issues/18119
if has("win32") | set isfname+=(,) | endif
if has("patch-8.2.4325") && exists("+wildoptions") | set wildoptions=pum | endif
if exists("+termguicolors") | set termguicolors | endif
if exists("+clipboard") && exists("+clientserver") | set clipboard=unnamedplus | endif
if exists("+persistent_undo")
    set undofile

    if has("unix")
        set undodir=~/.vim/undodir
    elseif has("win32")
        set undodir=~/vimfiles/undodir
    endif
endif

" }}}

" Plugins: {{{

call plug#begin()
Plug 'neoclide/coc.nvim', { 'branch': 'release' }
Plug 'sheerun/vim-polyglot', { 'commit': 'f5393cf', 'frozen': 1 }
Plug 'preservim/nerdtree', { 'on': ['NERDTreeToggle'], 'commit': '9b465ac', 'frozen': 1 }
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'morhetz/gruvbox'

Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

if has("patch-9.0.1799")
    packadd! editorconfig
else
    Plug 'editorconfig/editorconfig-vim'
endif
call plug#end()

" }}}

" Plugin Configuration: {{{

" Vim airline
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter = 'default'
let g:airline_theme='gruvbox'

" FZF
let g:fzf_vim = {}
let g:fzf_layout = { 'down': '40%' }

" coc.nvim
function! CocUserSettings()
    set nowritebackup
    set updatetime=300
    set signcolumn=yes

    inoremap <silent><expr> <TAB>
          \ coc#pum#visible() ? coc#pum#next(1) : "\<Tab>"

    inoremap <silent><expr> <C-f> coc#refresh()
    inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

    " Make <CR> to accept selected completion item or notify coc.nvim to format
    " <C-g>u breaks current undo, please make your own choice
    inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                                  \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

    " Use `[g` and `]g` to navigate diagnostics
    " Use `:CocDiagnostics` to get all diagnostics of current buffer in location list
    nmap <silent><nowait> [g <Plug>(coc-diagnostic-prev)
    nmap <silent><nowait> ]g <Plug>(coc-diagnostic-next)

    " GoTo code navigation
    nmap <silent><nowait> gd <Plug>(coc-definition)
    nmap <silent><nowait> gy <Plug>(coc-type-definition)
    nmap <silent><nowait> gi <Plug>(coc-implementation)
    nmap <silent><nowait> gr <Plug>(coc-references)
    nmap <leader>rn <Plug>(coc-rename)

    " Use K to show documentation in preview window
    nnoremap <silent> K :call ShowDocumentation()<CR>

    function! ShowDocumentation()
      if CocAction('hasProvider', 'hover')
        call CocActionAsync('doHover')
      else
        call feedkeys('K', 'in')
      endif
    endfunction

    augroup mygroup
      autocmd!
      " Setup formatexpr specified filetype(s)
      autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
    augroup end

    " Add `:Format` command to format current buffer
    command! -nargs=0 Format :call CocActionAsync('format')

    " Add `:Fold` command to fold current buffer
    command! -nargs=? Fold :call     CocAction('fold', <f-args>)

    " Add `:OR` command for organize imports of the current buffer
    command! -nargs=0 OR   :call     CocActionAsync('runCommand', 'editor.action.organizeImport')
endfunction

" Recommended way for checking if coc was loaded. https://github.com/neoclide/coc.nvim/discussions/5423
autocmd User CocNvimInit call CocUserSettings()

" }}}

" Keymaps: {{{

nnoremap <Leader><BS> <Cmd>nohlsearch<CR>
nnoremap <Leader>tx <Cmd>split<CR>
nnoremap <Leader>ty <Cmd>vsp<CR><C-w>l
nnoremap <Leader>th <Cmd>term<CR>
nnoremap <Leader>tv <Cmd>vertical terminal<CR>
nnoremap <Leader>te <Cmd>tabedit<CR>
nnoremap <Leader>tp <Cmd>tabprevious<CR>
nnoremap <Leader>tn <Cmd>tabnext<CR>
tnoremap <Esc><Esc> <C-\><C-n>
nnoremap <Leader>bd <Cmd>bd<CR>
nnoremap <Leader>tb <Cmd>call util#ToggleBackground()<CR>
nnoremap <F2> <Cmd>call util#SynStack()<CR>

" Plugins
nnoremap <Leader>ff <Cmd>NERDTreeToggle<CR>
nnoremap <Leader><Leader> <Cmd>Files<CR>
nnoremap <Leader>ls <Cmd>Buffers<CR>

" }}}

colorscheme gruvbox
