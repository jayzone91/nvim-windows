-- [[
-- oil.nvim
-- Neovim file explorer: edit your filesystem like a buffer
-- https://github.com/stevearc/oil.nvim
-- ]]
return {
  "stevearc/oil.nvim",
  lazy = false,
  dependencies = {
    -- [[
    -- nvim-web-devicons
    -- lua `fork` of vim-web-devicons for neovim
    -- https://github.com/nvim-tree/nvim-web-devicons
    -- ]]
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    require("oil").setup({
      columns = { "icon" },
      view_options = {
        show_hidden = true,
      },
      keymaps = {
        ["q"] = "actions.close",
        ["<ESC>"] = "actions.close",
        ["<BS>"] = "actions.parent",
      },
    })

    vim.keymap.set(
      "n",
      "<leader>e",
      "<CMD>Oil --float<CR>",
      { desc = "Open parent dir in Oil" }
    )
  end,
}
