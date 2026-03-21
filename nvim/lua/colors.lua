-- Markdown Style for Neovim
-- catppuccin mocha 팔레트 기반 render-markdown.nvim 하이라이트

-- catppuccin 팔레트 로드
local ok, palettes = pcall(require, "catppuccin.palettes")
if not ok then
  vim.notify("catppuccin not loaded yet, skipping markdown colors", vim.log.levels.WARN)
  return
end

local p = palettes.get_palette("mocha")

-- Heading 배경 (은은한 톤)
local heading_bg = {
  { bg = "#313244", fg = p.pink },
  { bg = "#2f3140", fg = p.lavender },
  { bg = "#2d303a", fg = p.blue },
  { bg = "#2c2f38", fg = p.sky },
  { bg = "#2a2d36", fg = p.teal },
  { bg = "#282b34", fg = p.green },
}

for i, hl in ipairs(heading_bg) do
  vim.api.nvim_set_hl(0, "RenderMarkdownH" .. i .. "Bg", { bg = hl.bg, fg = hl.fg, bold = true })
  vim.api.nvim_set_hl(0, "RenderMarkdownH" .. i, { fg = hl.fg, bold = true })
end

-- 체크박스
vim.api.nvim_set_hl(0, "RenderMarkdownChecked", { fg = p.green })
vim.api.nvim_set_hl(0, "RenderMarkdownUnchecked", { fg = p.overlay1 })
vim.api.nvim_set_hl(0, "RenderMarkdownTodo", { fg = p.yellow })

-- 코드블록
vim.api.nvim_set_hl(0, "RenderMarkdownCode", { bg = "#1e1e2e" })
vim.api.nvim_set_hl(0, "RenderMarkdownCodeInline", { fg = p.pink, italic = true })

-- 불릿 / 링크
vim.api.nvim_set_hl(0, "RenderMarkdownBullet", { fg = p.flamingo })
vim.api.nvim_set_hl(0, "RenderMarkdownLink", { fg = p.sky, underline = true })

-- 테이블
vim.api.nvim_set_hl(0, "RenderMarkdownTableHead", { fg = p.lavender, bold = true })
vim.api.nvim_set_hl(0, "RenderMarkdownTableRow", { fg = p.subtext0 })
