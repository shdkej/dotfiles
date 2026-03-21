-------------------------------------------------
-- core.lua
-- Step 1에서 하던: 옵션, 키맵, autocmd
-- 여기에 telescope용 키맵 일부 추가
-------------------------------------------------

-----------------
-- 기본 옵션들 --
-----------------
local o = vim.opt

-- UI / 가독성
o.number = true
o.relativenumber = true
o.cursorline = true
-- o.colorcolumn = "80"
o.termguicolors = true
o.signcolumn = "yes"
o.scrolloff = 4
o.sidescrolloff = 4

-- 들여쓰기 / 탭 스타일
o.expandtab = true
o.shiftwidth = 2
o.tabstop = 2
o.softtabstop = 2
o.smartindent = true

-- 검색 관련
o.ignorecase = true
o.smartcase = true
o.incsearch = true
o.hlsearch = true

-- 편의
o.wrap = false
o.swapfile = false
o.undofile = true
o.updatetime = 250
o.timeoutlen = 400
o.splitright = true
o.splitbelow = true
o.clipboard = "unnamedplus"
o.textwidth = 0 -- 자동 줄바꿈 강제 안 함

-----------------
-- 리더 키 --
-----------------

local map = vim.keymap.set
local opts_silent = { noremap = true, silent = true }

---------------------------------
-- 저장 / 종료 / 검색 하이라이트 해제
---------------------------------
map("n", "<leader>w", ":w<CR>", opts_silent)
map("n", "<leader>q", ":q<CR>", opts_silent)
map("n", "<leader>/", ":noh<CR>", opts_silent)

-- insert 모드에서 Ctrl-c = ESC
map("i", "<C-c>", "<ESC>", { noremap = true })

---------------------------------
-- Quickfix / Location list 흐름
---------------------------------
map("n", "<C-n>", ":cnext<CR>:lnext<CR>", opts_silent)
map("n", "<C-m>", ":cprevious<CR>:lprevious<CR>", opts_silent)
map("n", "<leader>a", ":cclose<CR>:lclose<CR>", opts_silent)

---------------------------------
-- 버퍼 네비 (너의 F5 / F6 / leader+4 스타일)
---------------------------------
map("n", "<C-S-t>", ":enew<CR>", opts_silent) -- 새 빈 버퍼
map("n", "<F5>", ":bprevious!<CR>", opts_silent)
map("n", "<F6>", ":bnext!<CR>", opts_silent)
map("i", "<F5>", "<C-o>:bprevious!<CR>", opts_silent)
map("i", "<F6>", "<C-o>:bnext!<CR>", opts_silent)
map("n", "<leader>4", ":bp <BAR> bd #<CR>", opts_silent) -- 이전 버퍼로 돌아가며 현재 닫기

-- 창 이동 (스플릿 간)
map("n", "<C-h>", "<C-w>h", opts_silent)
map("n", "<C-j>", "<C-w>j", opts_silent)
map("n", "<C-k>", "<C-w>k", opts_silent)
map("n", "<C-l>", "<C-w>l", opts_silent)

-- 비주얼 모드에서 블록 위/아래로 이동
map("v", "J", ":m '>+1<CR>gv=gv", opts_silent)
map("v", "K", ":m '<-2<CR>gv=gv", opts_silent)

---------------------------------
-- 시스템 클립보드 연동
---------------------------------
map({ "n", "v" }, "<leader>y", [["+y]], opts_silent)
map("n", "<leader>Y", [["+Y]], opts_silent)
map({ "n", "v" }, "<leader>d", [["+d]], opts_silent)
map({ "n", "v" }, "<leader>p", [["+p]], opts_silent)

-------------------------------------------------
-- 마지막 커서 위치 복귀
-------------------------------------------------
vim.api.nvim_create_autocmd("BufReadPost", {
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, [["]])
    local line = mark[1]
    local col = mark[2]
    local line_count = vim.api.nvim_buf_line_count(0)
    if line > 0 and line <= line_count then
      pcall(vim.api.nvim_win_set_cursor, 0, { line, col })
    end
  end,
})

-------------------------------------------------
-- 저장 전 trailing whitespace 제거
-------------------------------------------------
local function trim_trailing_whitespace()
  local save = vim.fn.winsaveview()
  vim.cmd([[%s/\s\+$//e]])
  vim.fn.winrestview(save)
end

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  callback = trim_trailing_whitespace,
})

-------------------------------------------------
-- YAML은 2스페이스 인덴트
-------------------------------------------------
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "yaml", "yml" },
  callback = function()
    vim.opt_local.tabstop = 2
    vim.opt_local.softtabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.expandtab = true
  end,
})
vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    vim.opt_local.conceallevel = 2
    vim.opt_local.concealcursor = "nc"
    vim.opt_local.spell = false
    vim.opt_local.wrap = true
    vim.opt_local.linebreak = true
    vim.opt_local.breakindent = true
    vim.opt_local.signcolumn = "no"
    -- vim.opt_local.number = false
    -- vim.opt_local.relativenumber = false
  end,
})

-------------------------------------------------
-- Telescope 단축키 자리 예약
-- (Step 2에서 이제 실제 telescope를 깔 거라 바로 매핑 가능)
-- - <leader>f : 파일 찾기  (네 과거 fzf <leader>f 역할)
-- - <leader>s : 검색 (Ag / ripgrep 역할)
-- - <leader>b : 열린 버퍼 목록
-------------------------------------------------
vim.keymap.set("n", "<leader>f", function()
  require("telescope.builtin").find_files()
end, { noremap = true, silent = true })

vim.keymap.set("n", "<leader>s", function()
  require("telescope.builtin").live_grep()
end, { noremap = true, silent = true })

vim.keymap.set("n", "<Space>", function()
  require("telescope.builtin").grep_string({ search = vim.fn.expand("<cword>") })
end, { silent = true })

vim.keymap.set("n", "<leader>b", function()
  require("telescope.builtin").buffers()
end, { noremap = true, silent = true })

-- Cmd + / → 주석 토글
vim.keymap.set("n", "<M-/>", function()
  require("Comment.api").toggle.linewise.current()
end, { noremap = true, silent = true })

vim.keymap.set("v", "<M-/>", function()
  local esc = vim.api.nvim_replace_termcodes('<ESC>', true, false, true)
  vim.api.nvim_feedkeys(esc, 'nx', false)
  require("Comment.api").toggle.linewise(vim.fn.visualmode())
end, { noremap = true, silent = true })

-- 수동 포맷: \F
vim.keymap.set("n", "<leader>F", function()
  require("conform").format({ async = true, lsp_fallback = true })
end, { noremap = true, silent = true, desc = "Format code" })

-- 안전하게 telescope 불러오는 helper
local function tb(fn)
  return function()
    require("telescope.builtin")[fn]()
  end
end

-- 현재 리포에서 변경된 파일들(status)
vim.keymap.set("n", "<leader>gs", tb("git_status"), {
  noremap = true,
  silent = true,
  desc = "Git status (changed files)",
})

-- 브랜치 목록 → 선택하면 checkout
vim.keymap.set("n", "<leader>gb", tb("git_branches"), {
  noremap = true,
  silent = true,
  desc = "Git branches (checkout)",
})

-- 커밋 로그 → 선택하면 해당 커밋 diff preview
vim.keymap.set("n", "<leader>gl", tb("git_commits"), {
  noremap = true,
  silent = true,
  desc = "Git log (commits)",
})

-- 현재 파일의 커밋 히스토리만 보고 싶을 때
vim.keymap.set("n", "<leader>gL", tb("git_bcommits"), {
  noremap = true,
  silent = true,
  desc = "Git log for current file",
})

-- 현재 hunk 미리보기 (gitsigns)
vim.keymap.set("n", "<leader>gp", function()
  require("gitsigns").preview_hunk()
end, {
  noremap = true,
  silent = true,
  desc = "Preview hunk",
})

-- 현재 hunk stage (stage selected change)
vim.keymap.set("n", "<leader>ga", function()
  require("gitsigns").stage_hunk()
end, {
  noremap = true,
  silent = true,
  desc = "Stage hunk",
})

-- 현재 파일 blame
vim.keymap.set("n", "<leader>gB", function()
  vim.cmd("G blame")
end, {
  noremap = true,
  silent = true,
  desc = "Git blame (fugitive)",
})

-- Git 전체 상태 보기 (fugitive)
vim.keymap.set("n", "<leader>gS", function()
  vim.cmd("G")
end, {
  noremap = true,
  silent = true,
  desc = "Git status (fugitive)",
})

-- 최근 파일 보기 (Telescope)
vim.keymap.set("n", "<leader>r", "<cmd>Telescope oldfiles<CR>", { noremap = true, silent = true, desc = "Recent files" })

local term_buf = nil
local term_win = nil

function _ToggleTerm()
  if term_win and vim.api.nvim_win_is_valid(term_win) then
    -- 터미널 열려 있으면 닫기
    vim.api.nvim_win_close(term_win, true)
    term_win = nil
  else
    -- 터미널 새로 열기
    vim.cmd("botright split term://zsh")
    vim.cmd("resize 15")
    term_win = vim.api.nvim_get_current_win()
    term_buf = vim.api.nvim_get_current_buf()
  end
end

-- \t로 토글
vim.keymap.set({ "n", "t" }, "<leader>t", _ToggleTerm, { noremap = true, silent = true, desc = "Toggle terminal" })


-------------------------------------------------
-- 시작 메시지 (심리적 피드백)
-------------------------------------------------
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    vim.notify("Neovim Step 2: treesitter + telescope ready 🔍")
  end,
})
