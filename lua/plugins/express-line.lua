-- [[
-- express_line.nvim
-- WIP: Statusline written in pure lua. Supports co-routines, functions and jobs.
-- https://github.com/tjdevries/express_line.nvim
-- ]]

return {
  "tjdevries/express_line.nvim",
  lazy = false,
  dependencies = {
    -- [[
    -- plenary.nvim
    -- plenary: full; complete; entire; absolute; unqualified.
    -- All the lua functions I don't want to write twice.
    -- https://github.com/nvim-lua/plenary.nvim
    -- ]]
    "nvim-lua/plenary.nvim",
    -- [[
    -- nvim-web-devicons
    -- lua `fork` of vim-web-devicons for neovim
    -- https://github.com/nvim-tree/nvim-web-devicons
    -- ]]
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    local builtin = require("el.builtin")
    local extensions = require("el.extensions")
    local subscribe = require("el.subscribe")
    local sections = require("el.sections")

    require("el").setup({
      generator = function()
        local segments = {}

        table.insert(segments, extensions.mode)
        table.insert(segments, " ")
        table.insert(
          segments,
          subscribe.buf_autocmd("el-git-branch", "BufEnter", function(win, buf)
            local branch = extensions.git_branch(win, buf)
            if branch then
              return branch
            end
          end)
        )
        table.insert(
          segments,
          subscribe.buf_autocmd(
            "el-git-changes",
            "BufWritePost",
            function(win, buf)
              local changes = extensions.git_changes(win, buf)
              if changes then
                return changes
              end
            end
          )
        )
        table.insert(segments, function()
          local task_count = #require("misery.scheduler").tasks
          if task_count == 0 then
            return ""
          else
            return string.format(" (Queued Events: %d)", task_count)
          end
        end)
        table.insert(segments, sections.split)
        table.insert(segments, "%f")
        table.insert(segments, sections.split)
        table.insert(
          segments,
          subscribe.buf_autocmd("el_file_icon", "BufRead", function(_, buffer)
            return extensions.file_icon(_, buffer)
          end)
        )
        table.insert(segments, builtin.filetype)
        table.insert(segments, "[")
        table.insert(segments, builtin.line_with_width(3))
        table.insert(segments, ":")
        table.insert(segments, builtin.column_with_width(2))
        table.insert(segments, "]")

        return segments
      end,
    })
  end,
}
