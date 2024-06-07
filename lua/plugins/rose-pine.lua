return({
  "rose-pine/neovim",
  name = "rose-pine",
  priority = 1000,
  opts = {
    variant = "moon",
    dark_variant = "moon",
    extend_background_behind_borders = true,
    styles = {
      transparency = true,
    },
    highlight_groups = {
      TelescopeBorder = { fg = "highlight_high", bg = "none" },
      TelescopeNormal = { bg = "none" },
      TelescopePromptNormal = { bg = "base" },
      TelescopeResultsNormal = { fg = "subtl", bg = "none" },
      TelescopeSelection = { fg = "text", bg = "base" },
      TelescopeSelectionCaret = { fg = "rose", bg = "rose" },
    },
  },
  config = function(_, opts)
    require("rose-pine").setup(opts)
    vim.cmd([[colorscheme rose-pine]])
  end,
})
