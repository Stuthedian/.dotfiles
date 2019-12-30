set nocompatible 
set showcmd
set hidden
set number relativenumber
set nowrap
set tabstop=4
set shiftwidth=4
set tildeop
set colorcolumn=80
highlight ColorColumn ctermbg=darkred

filetype on
autocmd FileType c :set cindent

let mapleader = "\<F2>"
nnoremap <Space> <Nop>
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
"source ~/Docs/cscope_maps.vim

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

"Airline
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#buffer_nr_show = 1
"let g:airline#extensions#tabline#formatter = 'unique_tail'

"Cscope
nnoremap <Leader>s :cs find s <C-R>=expand("<cword>")<CR><CR>
nnoremap <Leader>g :cs find g <C-R>=expand("<cword>")<CR><CR>
nnoremap <Leader>c :cs find c <C-R>=expand("<cword>")<CR><CR>
nnoremap <Leader>t :cs find t <C-R>=expand("<cword>")<CR><CR>
nnoremap <Leader>e :cs find e <C-R>=expand("<cword>")<CR><CR>
nnoremap <Leader>f :cs find f <C-R>=expand("<cfile>")<CR><CR>
nnoremap <Leader>i :cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
nnoremap <Leader>d :cs find d <C-R>=expand("<cword>")<CR><CR>
nnoremap <Leader>a :cs find a <C-R>=expand("<cword>")<CR><CR>
