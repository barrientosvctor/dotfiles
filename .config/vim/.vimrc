" ===============================================================
" Vimrc Configuration File (Working since Vim 9.1)
" ===============================================================

" Settings: {{{

set number
set relativenumber
set hlsearch
set showmatch
set incsearch
set encoding=utf-8
scriptencoding utf-8
set autoindent
set smartindent
set backspace=2
set hidden
set noswapfile
set nobackup
set wildmenu
set wildoptions=pum
let mapleader = ","

" Detecting (name) as file names. https://github.com/vim/vim/issues/18119
if has("win32") | set isfname+=(,) | endif
if has("gui_running")
    set guioptions-=T
    set guioptions-=m
    set guifont=JetBrains\ Mono:h14
endif

" }}}

" Plugins: {{{

call plug#begin()
Plug 'prabirshrestha/vim-lsp'
Plug 'mattn/vim-lsp-settings'
Plug 'sheerun/vim-polyglot'
call plug#end()

" }}}

" Plugin Configuration: {{{

" netrw
let g:netrw_liststyle = 3

" vim-lsp
let g:lsp_diagnostics_enabled = 1
let g:lsp_diagnostics_echo_cursor = 1
let g:lsp_diagnostics_float_cursor = 1
let g:lsp_document_highlight_enabled = 0

let g:lsp_completion_documentation_enabled = 1
let g:lsp_completion_documentation_delay = 1000

" Move notification messages to the right
let g:lsp_diagnostics_virtual_text_enabled = 0

" Gutter symbols
let g:lsp_document_code_action_signs_enabled = 1
let g:lsp_document_code_action_signs_hint = {'text': '→'}
let g:lsp_diagnostics_signs_error = {'text': '⨉'}
let g:lsp_diagnostics_signs_warning = {'text': '‼'}
let g:lsp_diagnostics_signs_info = {'text': 'ℹ'}
let g:lsp_diagnostics_signs_hint = {'text': '?'}
let g:lsp_diagnostics_signs_insert_mode_enabled = 0

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

    let g:lsp_format_sync_timeout = 1000
endfunction

augroup lsp_install
    au!
    autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END

" }}}

" Keymaps: {{{

nnoremap <Leader>th <Cmd>term<CR>
nnoremap <Leader>tv <Cmd>vertical terminal<CR>
nnoremap <Leader>te <Cmd>tabedit<CR>
nnoremap <Leader>tp <Cmd>tabprevious<CR>
nnoremap <Leader>tn <Cmd>tabnext<CR>
nnoremap <Leader>fe :Ex<CR>
nnoremap <Leader>ff :find **/

" }}}

packadd editorconfig
