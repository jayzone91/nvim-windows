-- [[
-- nvim-treesitter
-- Nvim Treesitter configurations and abstraction layer
-- https://github.com/nvim-treesitter/nvim-treesitter
-- ]]

return {
  "nvim-treesitter/nvim-treesitter",
  lazy = true,
  event = "BufEnter",
  build = ":TSUpdate",
  dependencies = {
    -- [[
    -- nvim-ts-autotag
    -- Use treesitter to auto close and auto rename html tag
    -- https://github.com/windwp/nvim-ts-autotag
    -- ]]
    "windwp/nvim-ts-autotag",
    -- [[
    -- nvim-ts-context-commentstring
    -- Neovim treesitter plugin for setting the commentstring
    -- based on the cursor location in a file.
    -- https://github.com/JoosepAlviste/nvim-ts-context-commentstring
    -- ]]
    {
      "JoosepAlviste/nvim-ts-context-commentstring",
      dependencies = {
        -- [[
        -- Comment.nvim
        -- 🧠 💪 // Smart and powerful comment plugin for neovim.
        -- Supports treesitter, dot repeat,
        -- left-right/up-down motions, hooks, and more
        -- https://github.com/numToStr/Comment.nvim
        -- ]]
        "numToStr/Comment.nvim",
      },
      config = function()
        local has_comment, comment = pcall(require, "Comment")
        if not has_comment then
          return
        end

        ---@diagnostic disable-next-line:missing-fields
        comment.setup({
          pre_hook = require(
            "ts_context_commentstring.integrations.comment_nvim"
          ).create_pre_hook(),
        })
      end,
    },
  },
  config = function()
    local config = require("nvim-treesitter.configs")

    ---@diagnostic disable-next-line:missing-fields
    config.setup({
      ensure_installed = { "c", "lua", "vim", "vimdoc", "query" },
      sync_install = false,
      auto_install = true,
      ignore_install = {},
      highlight = { enable = true },
      indent = { enable = true },
    })
    ---@diagnostic disable-next-line:missing-fields
    require("nvim-ts-autotag").setup({
      opts = {
        enable_close = true,
        enable_rename = true,
        enable_close_on_slash = true,
      },
    })
  end,
}
