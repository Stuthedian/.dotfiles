set nocompatible 
set showcmd
set hidden
set number relativenumber
"autocmd vimenter * NERDTree
"autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
"autocmd VimEnter * wincmd p
"au VimEnter * silent! !setxkbmap -option ctrl:swapcaps
"au VimLeave * silent! !setxkbmap -option
set number
set nowrap
set tabstop=4
set shiftwidth=4
filetype on
autocmd FileType c :set cindent
set tildeop
set colorcolumn=80
nnoremap <Space> <Nop>
"inoremap <F2> <80>k2
let mapleader = "\<F2>"
imap <Leader>[ a[]<Esc>i
"nmap <Leader>9 a()<Esc>i
"nmap <Leader>" a""<Esc>i
"nmap <Leader>' a''<Esc>i
"nmap <Leader>{ o{<Esc>o}<Esc>O
"nmap <Leader>, a<.h><Esc>T<i
"nmap <Leader>; A;<Esc>
"nmap <Leader>f a()<Esc><Leader>{
inoremap(; ()<Esc>i
"inoremap(( (
inoremap{; <Esc>o{<CR>}<Esc>O
"inoremap{{ {
"inoremap <s-9> <Nop>
"map <s-(> ()<Esc>i
"nmap <c-9> ()<Esc>i
if &term =~ 'xterm'
  let &t_SI .= "\<Esc>[6 q" " solid underscore
  let &t_EI .= "\<Esc>[2 q" " solid block
  " 1 or 0 -> blinking block
  " 3 -> blinking underscore
  " 4 -> solid underscore
  " Recent versions of xterm (282 or above) also support
  " 5 -> blinking vertical bar
  " 6 -> solid vertical bar
endif
set colorcolumn=80
highlight ColorColumn ctermbg=darkred
"source ~/Docs/cscope_maps.vim

nnoremap <C-_>s :cs find s <C-R>=expand("<cword>")<CR><CR>                  
nnoremap <C-_>g :cs find g <C-R>=expand("<cword>")<CR><CR>                  
nnoremap <C-_>c :cs find c <C-R>=expand("<cword>")<CR><CR>                  
nnoremap <C-_>t :cs find t <C-R>=expand("<cword>")<CR><CR>                  
nnoremap <C-_>e :cs find e <C-R>=expand("<cword>")<CR><CR>                  
nnoremap <C-_>f :cs find f <C-R>=expand("<cfile>")<CR><CR>                  
nnoremap <C-_>i :cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>                
nnoremap <C-_>d :cs find d <C-R>=expand("<cword>")<CR><CR>                  
nnoremap <C-_>a :cs find a <C-R>=expand("<cword>")<CR><CR> 

let g:airline#extensions#tabline#enabled = 1
"let g:NERDTreeWinPos = "right"
let g:airline#extensions#tabline#buffer_nr_show = 1
"let g:airline#extensions#tabline#formatter = 'unique_tail'
"experimental
"window
nmap <Leader>sw<left>  :topleft  vnew<CR>
nmap <Leader>sw<right> :botright vnew<CR>
nmap <Leader>sw<up>    :topleft  new<CR>
nmap <Leader>sw<down>  :botright new<CR>

" buffer
nmap <Leader>s<left>   :leftabove  vnew<CR>
nmap <Leader>s<right>  :rightbelow vnew<CR>
nmap <Leader>s<up>     :leftabove  new<CR>
nmap <Leader>s<down>   :rightbelow new<CR>
