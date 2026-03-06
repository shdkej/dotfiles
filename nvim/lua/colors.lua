-- Markdown Style Enhancer for Neovim
-- Author: 노성호 (KOP)
-- Description: catppuccin 테마 기반 색상 + headlines 스타일 통합

-- ensure headlines.nvim is loaded safely
local ok, headlines = pcall(require, "headlines")
if not ok then
  vim.notify("headlines.nvim not found! Please install it first.", vim.log.levels.WARN)
  return
end

-- headlines.nvim 설정
headlines.setup({
  markdown = {
    headline_highlights = {
      "Headline1",
      "Headline2",
      "Headline3",
      "Headline4",
      "Headline5",
      "Headline6",
    },
    bullets = { "◉", "○", "✸", "✿" },
  },
})

-- 색상 하이라이트 설정
vim.cmd [[
  " ===== Headings =====
  hi Headline1 guibg=#313244 guifg=#f5c2e7 gui=bold
  hi Headline2 guibg=#2f3140 guifg=#b4befe gui=bold
  hi Headline3 guibg=#2d303a guifg=#89b4fa gui=bold
  hi Headline4 guibg=#2c2f38 guifg=#74c7ec gui=bold
  hi Headline5 guibg=#2a2d36 guifg=#94e2d5 gui=bold
  hi Headline6 guibg=#282b34 guifg=#a6e3a1 gui=bold

  hi! markdownH1 guifg=#f5c2e7 gui=bold
  hi! markdownH2 guifg=#b4befe gui=bold
  hi! markdownH3 guifg=#89b4fa gui=bold
  hi! markdownH4 guifg=#74c7ec gui=bold
  hi! markdownH5 guifg=#94e2d5 gui=bold
  hi! markdownH6 guifg=#a6e3a1 gui=bold

  " ===== Text Formatting =====
  hi! markdownBold guifg=#f9e2af gui=bold
  hi! markdownItalic guifg=#f38ba8 gui=italic

  " ===== Code Blocks =====
  hi! markdownCode guifg=#f5c2e7 gui=italic
  hi! markdownCodeBlock guifg=#cba6f7 gui=NONE

  " ===== Lists / Quotes / Links =====
  hi! markdownListMarker guifg=#f38ba8 gui=bold
  hi! markdownBlockquote guifg=#9399b2 gui=italic
  hi! markdownLinkText guifg=#89dceb gui=underline
  hi! markdownUrl guifg=#94e2d5 gui=italic
]]

vim.notify("✨ Markdown style loaded (catppuccin-based)", vim.log.levels.INFO)
