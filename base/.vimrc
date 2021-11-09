source $VIMRUNTIME/defaults.vim
set encoding=utf-8

" allow buffers to become hidden
set hidden

if &t_Co > 2 || has("gui_running")
    " highlight search pattern
    set hlsearch
    nnoremap <leader><space> :nohlsearch<CR>
    " show line numbers and highlight current line
    set number relativenumber cursorline
endif

" use mouse
set mouse=a

" copy indentation from previous line
set autoindent

if has("autocmd")
    " Makefiles need actual tabs
    autocmd FileType make set tabstop=8 shiftwidth=8 noexpandtab
    " smaller tab widths
    autocmd FileType tex set tabstop=2 shiftwidth=2
    autocmd FileType yaml set tabstop=2 shiftwidth=2
    autocmd FileType html set tabstop=2 shiftwidth=2
    autocmd FileType tf set tabstop=2 shiftwidth=2
    autocmd FileType rst set tabstop=2 shiftwidth=2
    autocmd FileType javascript set tabstop=2 shiftwidth=2
    autocmd FileType json set tabstop=2 shiftwidth=2
endif

" use spaces instead of tabs
set tabstop=4 shiftwidth=4 expandtab smarttab

" change case in Insert mode
map! <C-F> <Esc>gUiw`]a

" ctrlp
let g:ctrlp_show_hidden = 1

" show diff between buffer and file
nnoremap <leader>i :w !git diff --no-index -- % -<CR>

" rg
nnoremap <leader>w :!rg --color=always --glob '\!.git/**' --hidden <C-R><C-W><CR>

" colors
colorscheme base16-default-dark
set termguicolors
