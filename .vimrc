source $VIMRUNTIME/defaults.vim
set encoding=utf-8

" allow buffers to become hidden
set hidden

if &t_Co > 2 || has("gui_running")
    " highlight search pattern
    set hlsearch
    nnoremap <leader><space> :nohlsearch<CR>
    " show line numbers and highlight current line
    set number cursorline
endif

" copy indentation from previous line
set autoindent

if has("autocmd")
    " Makefiles need actual tabs
    autocmd FileType make set tabstop=8 shiftwidth=8 noexpandtab
    " smaller tab widths
    autocmd FileType tex set tabstop=2 shiftwidth=2
    autocmd FileType yaml set tabstop=2 shiftwidth=2
endif

" use spaces instead of tabs
set tabstop=4 shiftwidth=4 expandtab smarttab

" use tab completion when line is not only whitespace
function! CleverTab()
    if strpart( getline('.'), 0, col('.')-1 ) =~ '^\s*$'
        return "\<Tab>"
    else
        return "\<C-P>"
    endif
endfunction
function! CleverShiftTab()
    if strpart( getline('.'), 0, col('.')-1 ) =~ '^\s*$'
        return "\<S-Tab>"
    else
        return "\<C-N>"
    endif
endfunction
inoremap <Tab> <C-R>=CleverTab()<CR>
inoremap <S-Tab> <C-R>=CleverShiftTab()<CR>

" change case in Insert mode
map! <C-F> <Esc>gUiw`]a

" use .vimrc_background generated by base16-shell
if filereadable(expand("~/.vimrc_background"))
    let base16colorspace=256
    source ~/.vimrc_background
endif
