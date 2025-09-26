" ===============================================================
" Vimrc Configuration File (Working since Vim 9.1)
" ===============================================================

" Settings: {{{

set bg=dark
set number
set relativenumber
set wrap
set hlsearch
set showmatch
syntax on
set encoding=utf-8
scriptencoding utf-8
set autoindent
set smartindent
set backspace=2
set hidden
set noswapfile
set nobackup
set laststatus=2
set wildmenu
filetype indent plugin on
let mapleader = ","

" Detecting (name) as file names. https://github.com/vim/vim/issues/18119
if has("win32") | set isfname+=(,) | endif
if has("patch-8.2.4325") && exists("+wildoptions") | set wildoptions=pum | endif

if has("gui_running")
    set guioptions-=T
    set guioptions-=m
    set guifont=JetBrains\ Mono:h16
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

if has("patch-9.0.1799")
    packadd! editorconfig
else
    Plug 'editorconfig/editorconfig-vim'
endif
call plug#end()

" }}}

" Plugin Configuration: {{{

" Gruvbox
let g:gruvbox_contrast_dark = "hard"

" NERDTree
let NERDTreeQuitOnOpen = 1
let g:NERDTreeMapActivateNode = "n"

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

    inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                                  \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

    nmap <silent><nowait> [g <Plug>(coc-diagnostic-prev)
    nmap <silent><nowait> ]g <Plug>(coc-diagnostic-next)
    nmap <silent><nowait> gd <Plug>(coc-definition)
    nmap <silent><nowait> gy <Plug>(coc-type-definition)
    nmap <silent><nowait> gi <Plug>(coc-implementation)
    nmap <silent><nowait> gr <Plug>(coc-references)
    nmap <leader>rn <Plug>(coc-rename)
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

    command! -nargs=0 Format :call CocActionAsync('format')
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
nnoremap <Leader>bd <Cmd>bd<CR>

" Plugins
nnoremap <Leader>ff <Cmd>NERDTreeToggle<CR>
nnoremap <Leader><Leader> <Cmd>Files<CR>
nnoremap <Leader>ls <Cmd>Buffers<CR>

" }}}

colorscheme gruvbox
