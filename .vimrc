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
set term=xterm-256color
set clipboard=unnamed
set t_Co=256
set cursorline
" set paste " 붙여넣기 계단현상 없애기 it makes prevent ultisnips
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

set colorcolumn=80
highlight OverLength ctermbg=240 ctermfg=white guibg=#592929
highlight ColorColumn guibg=#2d2d2d ctermbg=240 ctermfg=white
match OverLength /\%81v.\+/
set textwidth=80

" add yaml stuffs
" au! BufNewFile,BufReadPost *.{yaml,yml} set filetype=yaml foldmethod=indent
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab

autocmd BufReadPost quickfix nnoremap <buffer> <CR> <CR>
set completeopt+=preview
set completeopt+=menuone
set completeopt+=longest

fun! TrimWhitespace()
    let l:save = winsaveview()
    keeppatterns %s/\s\+$//e
    call winrestview(l:save)
endfun
au BufWritePre * :call TrimWhitespace()
"au BufRead,BufNewFile *.{go,py} match BadWhitespace /\s\+$/

nnoremap <leader>/ :noh<CR>
" multi line bash execute in vim
vnoremap <leader>c :'<,'> w !bash<CR>


" Plug
call plug#begin('~/.vim/plugged')
"
Plug 'junegunn/fzf', { 'do': './install --bin' }
Plug 'junegunn/fzf.vim'
Plug 'junegunn/goyo.vim'
Plug 'scrooloose/nerdtree'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'mhinz/vim-startify'
Plug 'vim-airline/vim-airline'
Plug 'vimwiki/vimwiki'
Plug 'ferrine/md-img-paste.vim'
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() } }

Plug 'dense-analysis/ale'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'prettier/vim-prettier', { 'do': 'npm install' }

Plug 'joshdick/onedark.vim'
"
call plug#end()

colorscheme onedark

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

let g:tagbar_type_markdown = {
    \ 'ctagstype' : 'markdown',
    \ "sort" : 0,
    \ 'kinds' : [
        \ 'h4:headings4',
        \ 'h:headings',
    \ ]
\ }

let g:tagbar_type_vimwiki = {
    \ 'ctagstype' : 'vimwiki',
    \ 'sort': 0,
    \ 'kinds' : [
        \ 'h4:headings4',
        \ 'h:Heading',
    \ ]
\ }

" vimwiki
let g:wiki_directory = '~/wiki-blog/content/'
let g:vimwiki_list = [{'path': g:wiki_directory,
                    \ 'syntax': 'markdown', 'ext': '.md',
                    \ 'auto_tags': 1
                    \}]
"let g:vimwiki_folding='expr'
"set foldlevelstart=1

"selected line move to Archive.md
vnoremap ta :'<, '> w >>~/wiki-blog/content/Archive.md <bar> normal gvd<CR>
autocmd FileType markdown imap [[ [[<C-x><C-o>
autocmd FileType markdown nnoremap <F12> :execute "VWB" <Bar> :lopen<CR>
autocmd FileType markdown nnoremap <silent><leader>wt :VimwikiTable<CR>
autocmd FileType markdown hi Title cterm=bold ctermfg=Yellow
autocmd FileType markdown inoremap <leader><tab> <c-t>
autocmd FileType markdown inoremap <s-tab> <c-d>
nmap <silent> <F2> :call ToggleTodo()<CR>
nmap <silent> <leader>t :Ag '\- \[ \]'<CR>

function! ToggleTodo()
    let s:inbox = '~/wiki-blog/content/INBOX.md'
    let s:currentfile = expad('%:t') == "INBOX.md"
    if s:currentfile
        execute 'e#'
    else
        execute 'e ' . s:inbox
    endif
endfunction

function! LastModified()
    if g:md_modify_disabled
        return
    endif
    if &modified
        let save_cursor = getpos(".")
        let n = min([10, line("$")])
        keepjumps exe '1,' . n . 's#^\(.\{,10}updated\s*: \).*#\1' .
            \ strftime('%Y-%m-%d %H:%M:%S +0900') . '#e'
        "if expand('#:t:r') != 'index'
        "    keepjumps exe '1, ' . n . 's#^\(.\{,10}parent\s*: \).*#\1' .
        "        \ '[[' . expand('#:r') . ']]'
        "endif
        call histdel('search', -1)
        call setpos('.', save_cursor)
    endif
endfunction

function! NewTemplate()
    let l:wiki_directory = v:false

    for wiki in g:vimwiki_list
        if expand('%:p:h') . '/' == expand(wiki.path)
            let l:wiki_directory = v:true
            break
        endif
    endfor

    if !l:wiki_directory
        return
    endif

    if line("$") > 1
        return
    endif

    let l:template = []
    call add(l:template, '---')
    call add(l:template, 'title   : ')
    call add(l:template, 'summary : ')
    call add(l:template, 'date    : ' . strftime('%Y-%m-%d %H:%M:%S +0900'))
    call add(l:template, 'updated : ' . strftime('%Y-%m-%d %H:%M:%S +0900'))
    call add(l:template, 'tags    : ')
    call add(l:template, 'parent  : [[' . expand("#:t:r") . "]]")
    call add(l:template, '---')
    call add(l:template, '')
    call add(l:template, '# ')
    call setline(1, l:template)
    execute 'normal! G'
    execute 'normal! $'

    echom 'new wiki page has created'
endfunction

let g:vimwiki_table_mappings = 0

augroup vimwikiauto
    au BufWritePre *.md call LastModified()
    au BufRead,BufNewFile *.md call NewTemplate()
    au FileType vimwiki inoremap <C-d> <C-r>=vimwiki#tbl#kbd_tab()<CR>
    au FileType vimwiki inoremap <C-a> <Left><C-r>=vimwiki#tbl#kbd_shift_tab()<CR>
    command! GREP :execute 'vimgrep '.expand('<cword>').' '.expand('%') | :copen | :cc
    au BufRead, BufNewFile *.vimwiki set filetype=vimwiki
    "au FileType vimwiki set spell spelllang=en_us
    au FileType vimwiki inoremap <C-R> <Down>=pumvisible() ? "\<lt>C-N>" : "\<lt>Down>"<CR>
    au FileType vimwiki nnoremap <silent><leader>q :VimwikiGoto diary/<C-R>=strftime('%Y-%m-01')<CR><CR>
augroup END

let g:md_modify_disabled = 0

" startify
nnoremap <silent> <leader>] :Startify <CR>
let g:startify_bookmarks = [
        \ { 'c': '~/.vimrc' },
        \ { 'd': g:wiki_directory . 'diary/diary.md' },
        \ { 'w': g:wiki_directory . 'index.md' },
        \ { 'j': g:wiki_directory . 'Journal.md' },
        \ { 't': g:wiki_directory . 'INBOX.md' },
        \ ]
let g:startify_lists = [
      \ { 'type': 'dir',       'header': ['   MRU '. getcwd()] },
      \ { 'type': 'files',     'header': ['   MRU']            },
      \ { 'type': 'bookmarks', 'header': ['   Bookmarks']      },
      \ { 'type': 'sessions',  'header': ['   Sessions']       },
      \ { 'type': 'commands',  'header': ['   Commands']       },
      \ ]
"ultisnips
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"
let g:UltiSnipsListSnippets="<c-tab>"
let g:UltiSnipsEditSplit="vertical"

"ALE
let g:ale_linters = {
    \   'python': ['flake8', 'pylint']
    \}

" coc
let g:coc_global_extensions = [
  \ 'coc-go',
  \ 'coc-yaml',
  \ 'coc-docker',
  \ 'coc-ultisnips',
  \ 'coc-python',
  \ 'coc-tsserver',
  \ 'coc-eslint',
  \ 'coc-prettier',
  \ ]
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)
inoremap <silent><expr> <c-@> coc#refresh()
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gr <Plug>(coc-references)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> K  :call CocActionAsync('doHover')<CR>


" 자동완성 메뉴에서 선택된 아이템 Confirm (Enter)
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm() : "\<CR>"

" eslint 자동 fix (저장 또는 직접 실행)
nnoremap <silent> <leader>af :CocCommand eslint.executeAutofix<CR>

" 코드 포맷팅 (Prettier, LSP)
nnoremap <silent> <leader>f :call CocAction('format')<CR>

" 빠른 오류 목록 열기
nnoremap <silent> <leader>q :CocList diagnostics<CR>

" yaml 문서 완성 강제 호출
inoremap <silent><expr> <C-Space> coc#refresh()

" 문제 있는 라인으로 빠르게 이동
nnoremap <silent> <leader>en :CocNext<CR>
nnoremap <silent> <leader>ep :CocPrev<CR>

" Hover 문서 보기
nnoremap <silent> <leader>h K



au FileType vimwiki let b:coc_suggest_disable = 1

" vim-go
" run :GoBuild or :GoTestCompile based on the go file
function! s:build_go_files()
  let l:file = expand('%')
  if l:file =~# '^\f\+_test\.go$'
    call go#test#Test(0, 1)
  elseif l:file =~# '^\f\+\.go$'
    call go#cmd#Build(0)
  endif
endfunction
autocmd FileType go nmap <leader>t  <Plug>(go-test)
autocmd FileType go nmap <leader>r  <Plug>(go-run)
autocmd FileType go nmap <leader>b :<C-u>call <SID>build_go_files()<CR>
autocmd FileType go nmap <Leader>c <Plug>(go-coverage-toggle)
"let g:go_fmt_command = "goimports"
let g:go_highlight_types = 1
let g:go_highlight_functions = 1
let g:go_highlight_calls = 1
let g:go_highlight_operators = 1
let g:go_highlight_build_constraint = 1
let g:rehash256 = 1
"let g:go_metalinter_enabled = ['vet', 'golint', 'errcheck']
"let g:go_metalinter_autosave = 1
"let g:go_metalinter_autosave_enabled = ['vet', 'golint']
"let g:go_metalinter_deadline = "5s"
let g:go_version_warning = 0
let g:go_code_completion_enabled = 0
let g:go_bin_path = "/home/sh/golang/bin"

" Prettier
let g:prettier#autoformat = 0
autocmd BufWritePre *.js,*.ts,*.json,*.html PrettierAsync

hi def mymdH4 ctermfg=cyan cterm=none
hi def myXLine ctermfg=140 cterm=none
match mymdH4 /####.*/
match myXLine /    -.*/

" 설정
source ~/.vim/vimconfig/keymaps.vim
