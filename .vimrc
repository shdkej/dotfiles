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
" set paste " 붙여넣기 계단현상 없애기 it makes prevent ultisnips
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

set colorcolumn=80
highlight OverLength ctermbg=240 ctermfg=white guibg=#592929
highlight ColorColumn guibg=#2d2d2d ctermbg=240 ctermfg=white
match OverLength /\%81v.\+/
set textwidth=80

" add yaml stuffs
au! BufNewFile,BufReadPost *.{yaml,yml} set filetype=yaml foldmethod=indent
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab

" Markdown
function! MarkdownLevel()
    if getline(v:lnum) =~ '^## .*$'
        return ">1"
    endif
    if getline(v:lnum) =~ '^#### .*$'
        return ">2"
    endif
    return "="
endfunction

au BufEnter *.{md,vimwiki} setlocal foldexpr=MarkdownLevel()
au BufEnter *.{md,vimwiki} setlocal foldmethod=expr
au BufEnter *.{md,vimwiki} normal zR

" Plug
call plug#begin('~/.vim/plugged') 
" 
Plug 'junegunn/fzf', { 'do': './install --bin' } 
Plug 'junegunn/fzf.vim' 
Plug 'flazz/vim-colorschemes'
Plug 'vim-airline/vim-airline' 
Plug 'scrooloose/nerdtree'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'
Plug 'majutsushi/tagbar'
Plug 'benmills/vimux'
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'mrk21/yaml-vim'
Plug 'skanehira/docker-compose.vim'
Plug 'mhinz/vim-startify'
Plug 'vimwiki/vimwiki'
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() } }

Plug 'dense-analysis/ale'
Plug 'mattn/vim-lsp-settings'
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/async.vim'
Plug 'prabirshrestha/vim-lsp'
Plug 'prabirshrestha/asyncomplete-lsp.vim'
Plug 'thomasfaingnaert/vim-lsp-snippets'
Plug 'thomasfaingnaert/vim-lsp-ultisnips'
Plug 'prabirshrestha/asyncomplete-ultisnips.vim'
Plug 'fatih/vim-go'
"
call plug#end()


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
nnoremap <silent> <leader>4 :bp <BAR> bd #<CR>
nnoremap <silent> <leader>5 :bprevious!<CR>
nnoremap <silent> <leader>6 :bnext!<CR>

"fzf
nnoremap <silent> <leader>f :FZF --preview=head\ -10\ {}<cr>
nnoremap <silent> <leader>F :FZF ~<cr>

" vimwiki
au BufRead, BufNewFile *.vimwiki set filetype=vimwiki
autocmd FileType vimwiki map <leader>d :VimwikiMakeDiaryNote
autocmd FileType vimwiki map <leader>g :VimwikiDiaryGenerateLinks

let g:vimwiki_list = [{'path': '~/vimwiki/',
                    \ 'syntax': 'markdown', 'ext': '.md'}]

function! LastModified()
    if g:md_modify_disabled
        return
    endif
    if &modified
        let save_cursor = getpos(".")
        let n = min([10, line("$")])
        keepjumps exe '1,' . n . 's#^\(.\{,10}updated\s*: \).*#\1' .
            \ strftime('%Y-%m-%d %H:%M:%S +0100') . '#e'
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
    call add(l:template, 'layout  : post')
    call add(l:template, 'title   : ')
    call add(l:template, 'summary : ')
    call add(l:template, 'date    : ' . strftime('%Y-%m-%d %H:%M:%S +0100'))
    call add(l:template, 'updated : ' . strftime('%Y-%m-%d %H:%M:%S +0100'))
    call add(l:template, 'tags    : ')
    call add(l:template, 'toc     : true')
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
    autocmd BufWritePre *.md call LastModified()
    autocmd BufRead,BufNewFile *.md call NewTemplate()
    autocmd FileType vimwiki inoremap <C-s> <C-r>=vimwiki#tbl#kbd_tab()<CR>
    autocmd FileType vimwiki inoremap <C-a> <Left><C-r>=vimwiki#tbl#kbd_shift_tab()<CR>
augroup END

let g:md_modify_disabled = 0

" startify
let g:startify_bookmarks = [
        \ { 'c': '~/.vimrc' },
        \ { 'd': '~/vimwiki/diary/diary.md' },
        \ ]
" ag
let g:ackprg = 'ag --nogroup --nocolor --column'
nnoremap <silent> <leader>s :Ag ~<cr>

" vimux
map <silent> <Leader>r :VimuxPromptCommand<CR>

"ultisnips
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"
let g:UltiSnipsListSnippets="<c-tab>"
let g:UltiSnipsEditSplit="vertical"
if has('python3')
    call asyncomplete#register_source(asyncomplete#sources#ultisnips#get_source_options({
        \ 'name': 'ultisnips',
        \ 'whitelist': ['*'],
        \ 'completor': function('asyncomplete#sources#ultisnips#completor'),
        \ }))
endif
"ALE
let g:ale_linters = {
    \   'python': ['flake8', 'pylint']
    \}

"delimitMate
let delimitMate_expand_cr=1

"lsp
if executable('pyls')
    " pip install python-language-server
    au User lsp_setup call lsp#register_server({
        \ 'name': 'pyls',
        \ 'cmd': {server_info->['pyls']},
        \ 'whitelist': ['python'],
        \ })
endif
if executable('docker-langserver')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'docker-langserver',
        \ 'cmd': {server_info->[&shell, &shellcmdflag, 'docker-langserver --stdio']},
        \ 'whitelist': ['dockerfile'],
        \ })
endif
if executable('yaml-language-server')
  augroup LspYaml
   autocmd!
   autocmd User lsp_setup call lsp#register_server({
       \ 'name': 'yaml-language-server',
       \ 'cmd': {server_info->['yaml-language-server', '--stdio']},
       \ 'whitelist': ['yaml', 'yaml.ansible'],
       \ 'workspace_config': {
       \   'yaml': {
       \     'validate': v:true,
       \     'hover': v:true,
       \     'completion': v:true,
       \     'customTags': [],
       \     'schemas': {},
       \     'schemaStore': { 'enable': v:true },
       \   }
       \ }
       \})
  augroup END
endif

function! s:on_lsp_buffer_enabled() abort
    setlocal omnifunc=lsp#complete
    setlocal signcolumn=yes
    nmap <buffer> gd <plug>(lsp-definition)
    nmap <buffer> <f2> <plug>(lsp-rename)
    " refer to doc to add more commands
endfunction

augroup lsp_install
    au!
    " call s:on_lsp_buffer_enabled only for languages that has the server registered.
    autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END
let g:lsp_log_verbose = 1
let g:lsp_log_file = expand('~/vim-lsp.log')

"asyncomplete
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <cr>    pumvisible() ? "\<C-y>" : "\<cr>"
imap <c-space> <Plug>(asyncomplete_force_refresh)
let g:asyncomplete_auto_popup = 1
function! s:check_back_space() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~ '\s'
endfunction

inoremap <silent><expr> <TAB>
  \ pumvisible() ? "\<C-n>" :
  \ <SID>check_back_space() ? "\<TAB>" :
  \ asyncomplete#force_refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
set completeopt+=preview

" vim-go
map <C-n> :cnext<CR>
map <C-m> :cprevious<CR>
nnoremap <leader>a :cclose<CR>
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
autocmd BufNewFile, BufRead *.go setlocal noexpandtab tabstop=4 shiftwidth=4
let g:go_fmt_command = "goimports"
let g:go_highlight_types = 1
let g:go_highlight_functions = 1
let g:go_highlight_calls = 1
let g:go_highlight_operators = 1
let g:go_highlight_build_constraint = 1
let g:rehash256 = 1
let g:molokai_original = 1
let g:go_metalinter_enabled = ['vet', 'golint', 'errcheck']
let g:go_metalinter_autosave = 1
let g:go_metalinter_autosave_enabled = ['vet', 'golint']
let g:go_metalinter_deadline = "5s"

" Markdown Preview
nmap <leader>m <Plug>MarkdownPreviewToggle

colorscheme molokai
