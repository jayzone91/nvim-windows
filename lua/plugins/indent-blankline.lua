-- [[
-- indent-blankline.nvim
-- Indent guides for Neovim
-- https://github.com/lukas-reineke/indent-blankline.nvim
-- ]]

return {
  "lukas-reineke/indent-blankline.nvim",
  lazy = true,
  event = "BufEnter",
  main = "ibl",
  opts = {
    scope = {
      enabled = true,
      show_exact_scope = true,
      injected_languages = true,
      show_start = true,
      highlight = { "Function", "Label" },
    },
  },
}
