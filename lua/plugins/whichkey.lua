-- [[
-- which-key.nvim
-- 💥 Create key bindings that stick. WhichKey is a lua
-- plugin for Neovim 0.5 that displays a popup with
-- possible keybindings of the command you started typing.
-- https://github.com/folke/which-key.nvim
-- ]]

return {
  "folke/which-key.nvim",
  lazy = true,
  event = "VeryLazy",
  init = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 300
  end,
  opts = {},
  config = function()
    local wk = require("which-key")

    wk.register({
      f = {
        name = "+find",
      },
      c = {
        name = "+symbols",
      },
      q = {
        name = "+quit",
      },
      s = {
        name = "+split",
      },
      x = {
        name = "+Trouble",
      },
      t = {
        name = "+Tabs",
      },
    }, { prefix = "<leader>" })
  end,
}
