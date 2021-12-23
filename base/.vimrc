source $VIMRUNTIME/defaults.vim
set encoding=utf-8

" allow buffers to become hidden
set hidden

" try to use vim-plug
" curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
" https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
if !empty(glob("~/.vim/autoload/plug.vim"))
    call plug#begin("~/.vim/plugged")
    Plug 'chriskempson/base16-vim'
    Plug 'ctrlpvim/ctrlp.vim'
    Plug 'davidhalter/jedi-vim'
    Plug 'ervandew/supertab'
    Plug 'easymotion/vim-easymotion'
    Plug 'airblade/vim-gitgutter'
    call plug#end()
endif

if &t_Co > 2 || has("gui_running")
    " highlight search pattern
    set hlsearch
    nnoremap <leader><space> :nohlsearch<CR>
    " show line numbers and highlight current line
    set number relativenumber cursorline
    " colors
    colorscheme default
    let base16colorspace=256
    if !exists('g:colors_name') || g:colors_name != 'base16-default-dark'
        colorscheme base16-default-dark
    endif
    if filereadable(expand("~/.vimrc_background"))
        source ~/.vimrc_background
    endif
endif

" use mouse
set mouse=a

" copy indentation from previous line
set autoindent

if has("autocmd")
    " actual tabs
    autocmd FileType make set tabstop=8 shiftwidth=8 noexpandtab
    autocmd FileType go set tabstop=4 shiftwidth=4 noexpandtab
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
