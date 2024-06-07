return {

  {
    "folke/todo-comments.nvim",
    lazy = true,
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      -- [[
      -- plenary.nvim
      -- plenary: full; complete; entire; absolute; unqualified.
      -- All the lua functions I don't want to write twice.
      -- https://github.com/nvim-lua/plenary.nvim
      -- ]]
      "nvim-lua/plenary.nvim",
    },
    opts = {},
  },
}
