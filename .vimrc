colo desert
set encoding=utf-8
set hlsearch " 검색어 하이라이팅
set nu " 줄번호
set autoindent " 자동 들여쓰기
set scrolloff=2
set wildmode=longest,list
set ts=4 "tag select
set sts=4 "st select
set sw=1 " 스크롤바 너비
set autowrite " 다른 파일로 넘어갈 때 자동 저장
set autoread " 작업 중인 파일 외부에서 변경됬을 경우 자동으로 불러옴
set cindent " C언어 자동 들여쓰기
set bs=eol,start,indent
set history=256
set laststatus=0 " 상태바 표시 항상
set paste " 붙여넣기 계단현상 없애기
set shiftwidth=4 " 자동 들여쓰기 너비 설정
set showmatch " 일치하는 괄호 하이라이팅
set smartcase " 검색시 대소문자 구별
set smarttab
set smartindent
set softtabstop=4
set tabstop=4
set expandtab
set ruler " 현재 커서 위치 표시
set incsearch
" set statusline=\ %<%l:%v\ [%P]%=%a\ %h%m%r\ %F\
set term=xterm-256color
set t_Co=256
" 마지막으로 수정된 곳에 커서를 위치함
au BufReadPost *
\ if line("'\"") > 0 && line("'\"") <= line("$") |
\ exe "norm g`\"" |
\ endif
" 파일 인코딩을 한국어로
if $LANG[0]=='k' && $LANG[1]=='o'
set fileencoding=korea
endif
" 구문 강조 사용
if has("syntax")
syntax on
endif

imap <C-c> <ESC>

set nocompatible
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
set rtp+=~/.fzf
call vundle#begin()
"
Plugin 'VundleVim/Vundle.vim'
Plugin 'vim-airline/vim-airline'
Plugin 'scrooloose/nerdtree'
Plugin 'airblade/vim-gitgutter'
Plugin 'tpope/vim-fugitive'
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'majutsushi/tagbar'
Plugin 'junegunn/fzf.vim'
Plugin 'AutoComplPop'
"
call vundle#end()
filetype plugin indent on

"NERDTree
nmap <F3> :NERDTreeToggle<CR>
let NERDTreeQuitOnOpen=1
let NERDTreeShowHidden=1

"ctrlp
let g:ctrlp_custom_ignore = {
			\ 'dir': '\.git$\|public$\|log$\|tmp$\|vendor$',
			\ 'file': '\v\.(exe|so|dll)$'
			\}

"tagbar
map <F4> :TagbarToggle<CR>

"airline
"use buffer
let g:airline#extensions#tabline#enabled = 1              " vim-airline 버퍼 목록 켜기
let g:airline#extensions#tabline#fnamemod = ':t'          " vim-airline 버퍼 목록 파일명만 출력
let g:airline#extensions#tabline#buffer_nr_show = 1       " buffer number를 보여준다
let g:airline#extensions#tabline#buffer_nr_format = '%s:' " buffer 
nnoremap <C-S-t> :enew<CR>
nnoremap <C-F5> :bprevious!<CR>
nnoremap <C-F6> :bnext!<CR>
nnoremap <C-F4> :bp <BAR> bd #<CR>

"fzf
nnoremap <silent> <leader>f :FZF --preview=head\ -10\ {}<cr>
nnoremap <silent> <leader>F :FZF ~<cr>
" Open files in horizontal split
nnoremap <silent> <Leader>s :call fzf#run({
\   'down': '40%',
\   'sink': 'botright split' })<CR>

" Open files in vertical horizontal split
nnoremap <silent> <Leader>v :call fzf#run({
\   'right': winwidth('.') / 2,
\   'sink':  'vertical botright split' })<CR>

"ag
let g:ackprg = 'ag --nogroup --nocolor --column'
