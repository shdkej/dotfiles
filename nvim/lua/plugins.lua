-------------------------------------------------
-- plugins.lua (Step 3)
-- lazy.nvim + telescope + treesitter  (+ NEW: lualine, catppuccin)
-- 목표:
--   - 시인성 향상 (catppuccin)
--   - 상태라인(lualine)로 현재 컨텍스트를 항상 확인 가능
-------------------------------------------------

-- lazy.nvim bootstrap (그대로 유지)
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({

  -------------------------------------------------
  -- Telescope: 파일/grep/버퍼 전환
  -------------------------------------------------
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    config = function()
      local actions = require("telescope.actions")
      require("telescope").setup({
        defaults = {
          layout_strategy = "flex",
          layout_config = {
            horizontal = { preview_width = 0.6 },
          },
          mappings = {
            i = {
              ["<esc>"] = actions.close, -- ESC로 빠르게 닫기
            },
          },
        },
      })
      -- telescope 키맵은 core.lua에서 이미 require 성공 시 매핑했기 때문에
      -- 여기서 다시 매핑할 필요는 없음.
    end,
  },

  -------------------------------------------------
  -- Treesitter: 향상된 하이라이팅/들여쓰기
  -------------------------------------------------
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        highlight = {
          enable = true,
        },
        indent = {
          enable = true,
        },
        git = {
          ignore = false,
        },
        ensure_installed = {
          "lua",
          "vim",
          "vimdoc",
          "bash",
          "yaml",
          "json",
          "markdown",
          "markdown_inline",
          "javascript",
          "typescript",
          "python",
          "go",
          "html",
          "css",
        },
      })
    end,
  },

  -------------------------------------------------
  -- NEW: catppuccin colorscheme
  --       부드러운 다크 톤, 눈 피로 적음.
  --       theme 이름 "catppuccin-mocha" 많이 씀.
  -------------------------------------------------
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000, -- colorscheme은 먼저 로드되도록 priority를 높게
    config = function()
      require("catppuccin").setup({
        flavour = "mocha", -- latte, frappe, macchiato, mocha 중 선택
        transparent_background = true,
        term_colors = true,
        integrations = {
          telescope = true,
          treesitter = true,
          native_lsp = { enabled = true },
          render_markdown = true,
        },
      })

      -- 실제 colorscheme 적용
      vim.cmd.colorscheme("catppuccin-mocha")

      -- colorcolumn, OverLength 같은 시각 보조를 catppuccin 위에서 다시 정의해줄 수도 있어.
      -- 긴 줄 하이라이트 (필요 시 주석 해제)
      -- vim.api.nvim_set_hl(0, "OverLength", { bg = "#592929", fg = "#ffffff" })
      -- vim.cmd([[match OverLength /\%81v.\+/]])
    end,
  },

  -------------------------------------------------
  -- NEW: lualine (상태줄)
  --       airline 대체. 가볍고 Lua-native.
  --       파일명, git branch, 위치, 모드 등 표시.
  -------------------------------------------------
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons", lazy = true }, -- devicons 없어도 동작은 하는데 있으면 예쁨
    config = function()
      -- catppuccin이 lualine용 theme도 제공하거든
      -- 없으면 'auto' 로 두고, 있으면 'catppuccin'으로
      require("lualine").setup({
        options = {
          theme                = "catppuccin",
          component_separators = { left = "", right = "" },
          section_separators   = { left = "", right = "" },
          always_divide_middle = true,
          globalstatus         = true, -- nvim 0.7+ 에서 전체에 하나의 statusline
        },
        sections = {
          -- lualine_a ~ lualine_z 순서로 왼→오른쪽
          lualine_a = { "mode" },
          lualine_b = { "branch", "diff", "diagnostics" },
          lualine_c = { { "filename", path = 1 } }, -- path=1: 상대경로, path=2: 전체경로
          lualine_x = { "encoding", "fileformat", "filetype" },
          lualine_y = { "progress" },
          lualine_z = { "location" }, -- line:col
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = { { "filename", path = 1 } },
          lualine_x = { "location" },
          lualine_y = {},
          lualine_z = {},
        },
      })
    end,
  },
  -------------------------------------------------
  -- nvim-tree: 폴더 트리 (NERDTree 대체)
  -------------------------------------------------
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("nvim-tree").setup({
        view = {
          width = 35,
          side = "left",
        },
        renderer = {
          highlight_git = true,
          highlight_opened_files = "name",
          icons = {
            show = {
              git = true,
              folder = true,
              file = false,
              folder_arrow = true,
            },
          },
        },
        filters = {
          dotfiles = false,
        },
        actions = {
          open_file = {
            quit_on_open = true, -- NERDTree처럼 파일 열면 자동 닫기
          },
        },
      })

      -- F3으로 토글
      vim.keymap.set("n", "<F3>", ":NvimTreeToggle<CR>", { noremap = true, silent = true })
    end,
  },
  -------------------------------------------------
  -- bufferline: 상단 버퍼 목록 (airline tabline 대체)
  -------------------------------------------------
  {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("bufferline").setup({
        options = {
          mode = "buffers",    -- 열린 버퍼들 보여주기
          numbers = "none",    -- 앞에 1: 2: 이런 번호 안 붙임 (필요하면 "ordinal")
          diagnostics = false, -- LSP 에러/워닝 뱃지 안 보여줌 (나중 Step 4 가서 다시 켤 수 있음)
          show_buffer_close_icons = false,
          show_close_icon = false,
          always_show_bufferline = true,
          color_icons = true,          -- devicons 색상 유지 (너무 칙칙하면 false로 해도 됨)
          separator_style = "thin",    -- 'slant', 'thick', 'thin', 또는 {left,right} 커스텀 가능
          enforce_regular_tabs = true, -- 탭 길이 비슷하게 맞춰서 들쑥날쑥 안 보이도록
          max_name_length = 30,
          max_prefix_length = 15,
          truncate_names = true,
          offsets = {
            {
              filetype = "NvimTree",
              text = "File Explorer",
              highlight = "Directory",
              separator = true,
            },
          },

          -- 버퍼명 표시 방식 등 텍스트 렌더링 커스터마이즈
          -- 이 부분으로 양쪽 괜한 장식/삼각형을 많이 줄일 수 있어
          custom_areas = {},
        },
      })

      -- 이미 core.lua 에서:
      --   <F5> :bprevious!
      --   <F6> :bnext!
      -- 그 흐름이 bufferline이랑 잘 맞으니까 추가 매핑은 지금은 생략.
    end,
  },

  -------------------------------------------------
  -- COMPLETION (nvim-cmp)
  -------------------------------------------------
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")

      cmp.setup({
        snippet = {
          expand = function(args) luasnip.lsp_expand(args.body) end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<CR>"]      = cmp.mapping.confirm({ select = true }),
          ["<Tab>"]     = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"]   = cmp.mapping(function(fallback)
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
      })
    end,
  },
  -------------------------------------------------
  -- mason: LSP/formatter 설치 관리자
  -------------------------------------------------
  {
    "williamboman/mason.nvim",
  },

  -------------------------------------------------
  -- mason-lspconfig: mason ↔ lspconfig 연결
  -------------------------------------------------
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = {
      "neovim/nvim-lspconfig",
    },
  },

  -------------------------------------------------
  -- nvim-lspconfig: 실제 LSP 클라이언트 설정
  -------------------------------------------------
  {
    "neovim/nvim-lspconfig",
    -- config는 여기서 바로 하지 않고 lsp_setup.lua에서 일괄 관리
  },

  -------------------------------------------------
  -- nvim-cmp (자동완성) + 관련 소스 + snippet
  -------------------------------------------------
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
    },
  },
  {
    "numToStr/Comment.nvim",
    config = function()
      require("Comment").setup()
    end,
  },
  -------------------------------------------------
  -- FORMATTING / LINTING (conform.nvim)
  -------------------------------------------------
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    config = function()
      require("conform").setup({
        formatters_by_ft = {
          javascript = { "prettier" },
          typescript = { "prettier" },
          json = { "prettier" },
          html = { "prettier" },
          css = { "prettier" },
          yaml = { "prettier" },
          markdown = { "prettier" },
          python = { "black" },
          go = { "gofumpt", "goimports" },
          lua = { "stylua" },
        },
        format_on_save = {
          timeout_ms = 1000,
          lsp_fallback = true,
        },
      })
    end,
  },
  -------------------------------------------------
  -- GIT SIGNS: show git hunks in the sign column
  -------------------------------------------------
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("gitsigns").setup({
        signs = {
          add          = { text = "▎" },
          change       = { text = "▎" },
          delete       = { text = "契" },
          topdelete    = { text = "契" },
          changedelete = { text = "▎" },
          untracked    = { text = "▎" },
        },
        preview_config = {
          border = "rounded",
        },
      })
    end,
  },

  -------------------------------------------------
  -- FUGITIVE: git status / commit / blame / diff
  -------------------------------------------------
  {
    "tpope/vim-fugitive",
    cmd = { "G", "Git", "Gdiffsplit", "Gblame", "GBrowse" },
  },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    },
    keys = {
      {
        "<leader>?",
        function()
          require("which-key").show({ global = false })
        end,
        desc = "Buffer Local Keymaps (which-key)",
      },
    },
  },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
    ft = { "markdown" },
    opts = {
      heading = {
        enabled = true,
        icons = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " },
        width = "full",
        border = false,
        sign = true,
      },
      code = {
        enabled = true,
        sign = true,
        language_name = true,
        language_icon = true,
        width = "full",
        border = "thin",
      },
      checkbox = {
        enabled = true,
        unchecked = { icon = "󰄱 ", highlight = "RenderMarkdownUnchecked" },
        checked = { icon = "󰱒 ", highlight = "RenderMarkdownChecked" },
        custom = {
          todo = { raw = "[-]", rendered = "󰥔 ", highlight = "RenderMarkdownTodo" },
        },
      },
      bullet = {
        enabled = true,
        icons = { "●", "○", "◆", "◇" },
      },
      pipe_table = {
        enabled = true,
        style = "full",
      },
      link = {
        enabled = true,
        image = "󰥶 ",
        hyperlink = "󰌹 ",
        custom = {
          web = { pattern = "^http", icon = "󰖟 " },
          github = { pattern = "github%.com", icon = "󰊤 " },
        },
      },
    },
  },
})
