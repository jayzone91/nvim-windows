-- [[
-- gitsigns.nvim
-- Git integration for buffers
-- https://github.com/lewis6991/gitsigns.nvim
-- ]]

return {
  "lewis6991/gitsigns.nvim",
  lazy = true,
  event = { "BufReadPre", "BufNewFile" },
  opts = {},
}
