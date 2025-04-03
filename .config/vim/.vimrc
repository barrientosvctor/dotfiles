set bg=dark
set undofile
set wrap
set noswapfile
set nobackup
set nowritebackup
set autoindent
set hidden
set hlsearch
set incsearch
syntax enable
filetype indent plugin on
let mapleader=","
let maplocalleader=","

if exists("+wildmenu") | set wildmenu | endif
if has("patch-8.2.4325") && exists("+wildoptions") | set wildoptions=pum | endif
if has("win32") | set undodir=~/vimfiles/undo | elseif has("unix") | set undodir=~/.vim/undo | endif
if exists("+smartindent") | set smartindent | endif

nnoremap <Esc> :nohlsearch<CR>
nnoremap <Leader>th :term<CR>
nnoremap <Leader>tv :vertical terminal<CR>
nnoremap <Leader>te :tabedit<CR>
nnoremap <Leader>tp :tabprevious<CR>
nnoremap <Leader>tn :tabnext<CR>
nnoremap <Leader>lb :ls<CR>:b<Space>
nnoremap <Leader>fe :NERDTreeToggle<CR>

call plug#begin()

Plug 'prabirshrestha/vim-lsp'
Plug 'prabirshrestha/asyncomplete.vim' | Plug 'prabirshrestha/asyncomplete-lsp.vim'
Plug 'mattn/vim-lsp-settings'
Plug 'hrsh7th/vim-vsnip' | Plug 'hrsh7th/vim-vsnip-integ'
Plug 'rafamadriz/friendly-snippets'
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }

call plug#end()

inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <cr>    pumvisible() ? asyncomplete#close_popup() : "\<cr>"
" <C-@> = <C-Space>
imap <C-@> <Plug>(asyncomplete_force_refresh)

function! s:on_lsp_buffer_enabled() abort
    setlocal omnifunc=lsp#complete
    setlocal signcolumn=yes
    if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif
    nmap <buffer> gd <plug>(lsp-definition)
    nmap <buffer> gr <plug>(lsp-references)
    nmap <buffer> gi <plug>(lsp-implementation)
    nmap <buffer> gt <plug>(lsp-type-definition)
    nmap <buffer> <leader>rn <plug>(lsp-rename)
    nmap <buffer> [g <plug>(lsp-previous-diagnostic)
    nmap <buffer> ]g <plug>(lsp-next-diagnostic)
    nmap <buffer> K <plug>(lsp-hover)
    nnoremap <buffer> <expr><c-f> lsp#scroll(+4)
    nnoremap <buffer> <expr><c-d> lsp#scroll(-4)
    let g:lsp_format_sync_timeout = 1000
endfunction

augroup lsp_install
    au!
    " call s:on_lsp_buffer_enabled only for languages that has the server registered.
    autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END

" Expand
imap <expr> <C-e>   vsnip#expandable()  ? '<Plug>(vsnip-expand)'         : '<C-e>'
smap <expr> <C-e>   vsnip#expandable()  ? '<Plug>(vsnip-expand)'         : '<C-e>'

" Jump forward or backward
imap <expr> <C-k>   vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'      : '<C-k>'
smap <expr> <C-k>   vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'      : '<C-k>'
imap <expr> <C-j> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<C-j>'
smap <expr> <C-j> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<C-j>'
