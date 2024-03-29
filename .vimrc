set nocompatible
set mouse=n ttymouse=xterm2
set gdefault
set showcmd
set clipboard=unnamedplus
set splitbelow splitright
set hidden
set number relativenumber
set ignorecase smartcase
set foldmethod=syntax foldnestmax=1 foldopen+=jump
set nowrap
set tabstop=2 shiftwidth=2 expandtab
set timeoutlen=1000 ttimeoutlen=10
set tildeop
set nofixendofline
set colorcolumn=80
highlight ColorColumn ctermbg=darkred
set cursorline
if exists('+termguicolors')
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
endif

set keymap=russian-jcukenwin
set iminsert=0
set imsearch=-1
set imcmdline
inoremap <C-q> <C-^>
cnoremap <C-q> <C-^>

function AstyleIndent()
  if !filereadable(".astylerc") || !executable("astyle")
    return
  endif
  silent !astyle -q --options=.astylerc %
  silent edit
endfunction

filetype on
autocmd FileType c :set cindent

let mapleader = "\<Space>"
nnoremap <Space> <Nop>
nnoremap <Leader>p "0p
nnoremap <Leader>P "0P
nnoremap <Leader>v :Vifm<CR>

noremap Y y$

nnoremap \ I//<Esc>
vnoremap \ <Esc>'<I/*<Esc>'>A*/<Esc>

nnoremap <Esc>k :resize +1<CR>
nnoremap <Esc>j :resize -1<CR>
nnoremap <Esc>h :vertical resize +1<CR>
nnoremap <Esc>l :vertical resize -1<CR>
"Autocomplete braces, quotes
inoremap( ()<Esc>i
inoremap(( (
inoremap[ []<Esc>i
inoremap[[ [
inoremap{ <Esc>o{<CR>}<Esc>O
inoremap{{ {
inoremap" ""<Esc>i
inoremap"" "
inoremap' ''<Esc>i
inoremap'' '


"Window
nnoremap <Leader>wh :topleft  vsp<CR>
nnoremap <Leader>wl :botright vsp<CR>
nnoremap <Leader>wk :topleft  sp<CR>
nnoremap <Leader>wj :botright sp<CR>

"Buffer
nnoremap <Leader>bh  :leftabove  vsp<CR>
nnoremap <Leader>bl  :rightbelow vsp<CR>
nnoremap <Leader>bk  :leftabove  sp<CR>
nnoremap <Leader>bj  :rightbelow sp<CR>

"Window navigation
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

nnoremap <C-s> <Nop>
nnoremap <C-q> <Nop>

"Vim-plug automatic installation
if empty(glob('~/.vim/autoload/plug.vim'))
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
                \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

"Plugins
call plug#begin('~/.vim/plugged')
Plug 'vifm/vifm.vim'
Plug 'vim-airline/vim-airline'
Plug 'moll/vim-bbye'
Plug 'tmux-plugins/vim-tmux-focus-events'
Plug 'christoomey/vim-tmux-navigator'
Plug 'sainnhe/gruvbox-material'
call plug#end()

set background=dark
let g:gruvbox_material_background = 'hard'
colorscheme gruvbox-material

"Airline
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#buffer_nr_show = 1
let g:airline#extensions#tabline#formatter = 'unique_tail'
let g:airline#extensions#keymap#enabled = 0
let g:airline#extensions#whitespace#enabled = 1
let g:airline#extensions#whitespace#checks = [ 'conflicts' ]

"Cscope
source /usr/local/share/gtags/gtags.vim
source /usr/local/share/gtags/gtags-cscope.vim
set csprg=gtags-cscope

if stridx(getcwd(), "me-group-3.0.0-2nd") != -1
  silent! cs add /media/hdd/home/default/Docs/me-group-3.0.0-2nd/GTAGS
elseif stridx(getcwd(), "me-group-3.0.0-3nd") != -1
  silent! cs add /media/hdd/home/default/Docs/me-group-3.0.0-3nd/GTAGS
else
  silent! cs add /media/hdd/home/default/Docs/me-group-3.0.0/GTAGS
endif

"Find this C symbol
nnoremap <Leader>s :cs find s <C-R>=expand("<cword>")<CR><CR>
"Find this definition
nnoremap <Leader>g :cs find g <C-R>=expand("<cword>")<CR><CR>
"Find functions calling this function
nnoremap <Leader>c :cs find c <C-R>=expand("<cword>")<CR><CR>
