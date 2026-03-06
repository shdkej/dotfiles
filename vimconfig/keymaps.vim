
imap <C-c> <ESC>
map <C-n> :cnext<CR>:lnext<CR>
map <C-m> :cprevious<CR>:lprevious<CR>
nnoremap <leader>a :cclose<CR>:lclose<CR>

"airline (use buffer)
let g:airline_disable_statusline = 1
let g:airline#extensions#tabline#enabled = 1              " vim-airline 버퍼 목록 켜기
let g:airline#extensions#tabline#fnamemod = ':t'          " vim-airline 버퍼 목록 파일명만 출력
let g:airline#extensions#tabline#buffer_nr_show = 1       " buffer number를 보여준다
let g:airline#extensions#tabline#buffer_nr_format = '%s:' " buffer
nnoremap <C-S-t> :enew<CR>
nnoremap <silent> <leader>4 :bp <BAR> bd #<CR>
nnoremap <silent> <F5> :bprevious!<CR>
nnoremap <silent> <F6> :bnext!<CR>
inoremap <silent> <F5> <C-O>:bprevious!<CR>
inoremap <silent> <F6> <C-O>:bnext!<CR>

"fzf
nnoremap <silent> <leader>f :FZF --preview=head\ -10\ {}<cr>
nnoremap <silent> <leader>F :FZF ~<cr>
imap <c-x><c-k> <plug>(fzf-complete-word)
imap <c-x><c-f> <plug>(fzf-complete-path)
" Open files in vertical horizontal split
nnoremap <silent> <Leader>v :call fzf#run({
\   'right': winwidth('.') / 2,
\   'sink':  'vertical botright split' })<CR>

command! -bang -nargs=* Ag call fzf#vim#ag_raw(<q-args>, fzf#vim#with_preview({'options': '--delimiter : --nth 4..'}), <bang>0)

" ag
map <leader>s :Ag<Space>
nnoremap <silent> <Space> :RG <C-R>=expand("<cword>")<CR><CR>
set grepprg=ag\ --vimgrep\ $*
set grepformat=%f:%l:%c:%m
nnoremap <silent> <F12> :GREP<CR>
vnoremap // y:Ag <C-R>=fnameescape(@")<CR><CR>



" 문자열 검색과 기타 git 단축어
function! s:git_root_rg()
  let l:git_root = systemlist('git rev-parse --show-toplevel')[0]
  if empty(l:git_root)
    echo "Not in a git repository"
    return
  endif
  let l:query = input('Grep for > ')
  if empty(l:query)
    return
  endif
  let l:command = 'rg --column --line-number --no-heading --color=always --smart-case --hidden --glob "!.git/*" ' . shellescape(l:query) . ' ' . l:git_root
  call fzf#vim#grep(l:command, 1, fzf#vim#with_preview(), 0)
endfunction

nnoremap <silent> <leader>gg :call <SID>git_root_rg()<CR>

nnoremap <silent> <leader>gl :call fzf#run({
  \ 'source': 'git log --oneline --color=always',
  \ 'options': '--ansi --preview "git show --color=always {1}" --bind shift-down:preview-down,shift-up:preview-up',
  \ })<CR>
function! s:open_commit(commit)
  execute ':tabnew'
  execute ':read !git show '.a:commit
endfunction

nnoremap <leader>gb :call fzf#run({
  \ 'source': 'git branch --all --color=always',
  \ 'sink*': function('s:git_checkout'),
  \ 'options': '--ansi --preview "git log -n 5 --color=always {1}"',
  \ })<CR>

function! s:git_checkout(branch)
  let l:clean_branch = substitute(a:branch, '^\* ', '', '')
  let l:clean_branch = substitute(l:clean_branch, 'remotes/', '', '')
  execute '!git checkout ' . shellescape(l:clean_branch)
  echo "Checked out ".l:clean_branch
endfunction

nnoremap <silent> <leader>gs :call fzf#run({
  \ 'source': 'git status --short',
  \ 'options': '--ansi --multi --preview "git diff --color=always -- {2}"',
  \ 'sink': 'e'
  \ })<CR>




" python command
autocmd FileType python nmap <leader>t  :VimuxRunCommand(pytest)
noremap <buffer> <F10> :exec '!python3 -m pdb' shellescape(@%, 1)<cr>
nnoremap <buffer> <F9> :exec '!python3' shellescape(@%, 1)<cr>




" Markdown Preview
nmap <leader>m <Plug>MarkdownPreviewToggle


" md-img-paste
autocmd FileType markdown nmap <buffer><silent> <leader>p :call mdip#MarkdownClipboardImage()<CR>
autocmd FileType vimwiki nmap <buffer><silent> <leader>p :call mdip#MarkdownClipboardImage()<CR>

" Goyo
nnoremap <silent><F7> :Goyo<CR>
