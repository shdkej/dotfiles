-------------------------------------------------
-- lsp_setup.lua (no direct require('lspconfig').setup())
-- mason + mason-lspconfig + cmp + custom lsp start
-------------------------------------------------

-----------------------------
-- nvim-cmp (자동완성)
-----------------------------
local cmp = require("cmp")
local luasnip = require("luasnip")

cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },

  mapping = cmp.mapping.preset.insert({
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { "i", "s" }),
    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { "i", "s" }),
  }),

  sources = cmp.config.sources({
    { name = "nvim_lsp" },
    { name = "luasnip" },
    { name = "buffer" },
    { name = "path" },
  }),

  formatting = {
    format = function(entry, vim_item)
      vim_item.menu = ({
        nvim_lsp = "[LSP]",
        buffer   = "[BUF]",
        path     = "[PATH]",
        luasnip  = "[SNIP]",
      })[entry.source.name]
      return vim_item
    end,
  },

  -- / (search)에서 버퍼 단어 완성
  cmp.setup.cmdline("/", {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = "buffer" }
    },
  }),

  -- : (cmdline)에서 path + cmd 완성
  cmp.setup.cmdline(":", {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources(
      { { name = "path" } },
      { { name = "cmdline" } }
    ),
  }),

  completion = {
    completopt = "menu,menuone,noselect",
  },
})

-----------------------------
-- 공통 on_attach (키맵)
-----------------------------
local function on_attach(client, bufnr)
  local map = function(mode, lhs, rhs)
    vim.keymap.set(mode, lhs, rhs, { noremap = true, silent = true, buffer = bufnr })
  end

  -- 너의 근육 그대로
  map("n", "gd", vim.lsp.buf.definition)
  map("n", "gr", vim.lsp.buf.references)
  map("n", "gi", vim.lsp.buf.implementation)
  map("n", "K", vim.lsp.buf.hover)

  map("n", "\\rn", vim.lsp.buf.rename)
  map("n", "\\ca", vim.lsp.buf.code_action)

  map("n", "]g", vim.diagnostic.goto_next)
  map("n", "[g", vim.diagnostic.goto_prev)
  map("n", "\\q", vim.diagnostic.setqflist)

  -- optional: 형식화 지원 서버면 format 명령도 매핑하고 싶으면 여기에
  -- map("n", "\\f", function() vim.lsp.buf.format({ async = true }) end)
end

-----------------------------
-- capabilities (cmp 연동)
-----------------------------
local capabilities = require("cmp_nvim_lsp").default_capabilities()

-----------------------------
-- mason / mason-lspconfig
-----------------------------
local mason = require("mason")
local mason_lspconfig = require("mason-lspconfig")

mason.setup({
  ui = {
    border = "rounded",
    icons = {
      package_installed = "✓",
      package_pending = "➜",
      package_uninstalled = "✗",
    },
  },
})

-- 우리가 관리할 서버들
mason_lspconfig.setup({
  ensure_installed = {
    "lua_ls",
    "pyright",
    "ts_ls", -- tsserver의 새 이름
    "yamlls",
  },
  automatic_installation = true,
})

-----------------------------------------------------------------
-- 핵심: 각 LSP 서버별로 "구성(vim.lsp.config)"을 우리가 직접 만들고
-- 버퍼 열릴 때 자동으로 vim.lsp.start() 시켜주는 방식
--
-- 이건 nvim-lspconfig가 내부적으로 하던 일을 우리가 수동으로 해 주는 거라
-- 더 이상 lspconfig.SERVER.setup() 호출이 필요 없다 → 경고 사라짐.
-----------------------------------------------------------------

-- 서버별 설정 템플릿
local server_settings = {
  lua_ls = {
    cmd = { "lua-language-server" },
    filetypes = { "lua" },
    root_markers = { ".git", ".luarc.json", ".luarc.jsonc", ".luacheckrc", ".stylua.toml" },
    settings = {
      Lua = {
        diagnostics = {
          globals = { "vim" },
        },
      },
    },
  },

  pyright = {
    cmd = { "pyright-langserver", "--stdio" },
    filetypes = { "python" },
    root_markers = { "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", ".git" },
  },

  ts_ls = {
    cmd = { "typescript-language-server", "--stdio" },
    filetypes = {
      "javascript", "javascriptreact", "javascript.jsx",
      "typescript", "typescriptreact", "typescript.tsx",
    },
    root_markers = { "package.json", "tsconfig.json", "jsconfig.json", ".git" },
  },

  gopls = {
    cmd = { "gopls" },
    filetypes = { "go", "gomod", "gowork", "gotmpl" },
    root_markers = { "go.work", "go.mod", ".git" },
  },

  yamlls = {
    cmd = { "yaml-language-server", "--stdio" },
    filetypes = { "yaml", "yml" },
    root_markers = { ".git" },
  },
}

-- 작은 유틸: 현재 버퍼의 root_dir 추정
local function guess_root(bufnr, markers)
  local filepath = vim.api.nvim_buf_get_name(bufnr)
  if filepath == "" then
    return vim.loop.cwd()
  end
  local dir = vim.fs.dirname(filepath)
  local root = vim.fs.find(markers or { ".git" }, {
    path = dir,
    upward = true,
    stop = vim.loop.os_homedir(),
    type = "directory",
  })[1]
  if root then
    return root
  end
  -- 못 찾으면 현재 디렉토리
  return dir
end

-- 서버 한 개의 설정을 바탕으로 vim.lsp.start() 해주는 함수
local function ensure_started_for_buf(server_name, bufnr)
  local cfg = server_settings[server_name]
  if not cfg then
    return
  end

  -- 파일타입이 맞는 버퍼만 attach
  local ft = vim.api.nvim_buf_get_option(bufnr, "filetype")
  local matches_ft = false
  for _, allowed in ipairs(cfg.filetypes or {}) do
    if ft == allowed then
      matches_ft = true
      break
    end
  end
  if not matches_ft then
    return
  end

  -- 이미 이 버퍼에 같은 서버가 붙어있으면 다시 안 붙인다
  for _, client in pairs(vim.lsp.get_clients({ bufnr = bufnr })) do
    if client.name == server_name then
      return
    end
  end

  -- root_dir 계산
  local root_dir = guess_root(bufnr, cfg.root_markers)

  -- vim.lsp.start()는 table을 받는데, 우리가 capabilities / on_attach을 주입해서 호출
  vim.lsp.start({
    name = server_name,
    cmd = cfg.cmd,
    root_dir = root_dir,
    capabilities = capabilities,
    on_attach = on_attach,
    settings = cfg.settings,
    -- filetypes는 start() 쪽에 직접 안 넘겨도 되지만 남겨도 무방
    filetypes = cfg.filetypes,
  })
end

-- mason이 설치한 서버 목록만 대상으로 삼자
local installed = mason_lspconfig.get_installed_servers()
local installed_lookup = {}
for _, name in ipairs(installed) do
  installed_lookup[name] = true
end

-- BufRead/BufNewFile 마다 해당 버퍼에 맞는 서버 attach 시도
vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
  callback = function(args)
    local bufnr = args.buf
    -- 각 서버에 대해, mason이 설치한 경우에만 attach 시도
    for server_name, _ in pairs(server_settings) do
      if installed_lookup[server_name] then
        ensure_started_for_buf(server_name, bufnr)
      end
    end
  end,
})

-------------------------------------------------
-- LSP Diagnostic UI 설정 (에러/워닝 표시)
-------------------------------------------------
vim.keymap.set("n", "\\e", vim.diagnostic.open_float, { noremap = true, silent = true })
