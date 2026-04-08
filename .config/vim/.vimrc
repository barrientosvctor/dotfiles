" ===============================================================
" Vimrc Configuration File (Working since Vim 9.1)
" ===============================================================

" Settings: {{{

set number
set relativenumber
set hlsearch
set showmatch
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
set wildignore+=**/node_modules/**,**/dist/**,**/.git/**,**/vendor/**
set nowritebackup
let mapleader = ","

if has("gui_running")
    set guioptions-=T
    set guioptions-=m
    set guifont=JetBrains\ Mono:h14
endif

if has('termguicolors')
  set termguicolors
endif

" }}}

" Plugins: {{{

call plug#begin()
Plug 'neoclide/coc.nvim', { 'branch': 'release' }
Plug 'vim-airline/vim-airline'
call plug#end()

" }}}

" Plugin Configuration: {{{

" netrw
let g:netrw_liststyle = 3

" coc.nvim
function! CocUserSettings()
    set updatetime=300
    set signcolumn=yes

    let g:coc_global_extensions = ['coc-json', 'coc-snippets']

    inoremap <silent><expr> <C-N>
          \ coc#pum#visible() ? coc#pum#next(1) : "\<C-N>"
    inoremap <expr><C-P> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

    inoremap <silent><expr> <c-space> coc#refresh()
    if !has("nvim") && !has("gui_running")
	    inoremap <silent><expr> <c-@> coc#refresh()
    endif

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


    " COC SNIPPETS
    let g:coc_snippet_next = '<TAB>'
    let g:coc_snippet_prev = '<S-TAB>'
endfunction

" Recommended way for checking if coc was loaded. https://github.com/neoclide/coc.nvim/discussions/5423
autocmd User CocNvimInit call CocUserSettings()

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
