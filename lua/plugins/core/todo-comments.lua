-- todo-comments
--
-- todo-comments is a plugin to highlight and search for todo comments like TODO, HACK, BUG in the code base. It is
-- very convenient to document directly in the code the next steps to do, or to document long-term issues left for
-- the future, like unresolved bugs or performance issues. Besides, it works very nicely with other plugins, like
-- Telescope or Trouble, to navigate between todo-comments, or code snippets (e.g. Luasnip), to define custom
-- todo-comment snippets to blazingly-fast add them to the code.

return {
  "folke/todo-comments.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  event = { "BufNewFile", "BufReadPre" },
  keys = function()
    --- Open todo-comments in the current project or in the current directory if an Oil buffer is open, using Telescope
    --- or Trouble.
    ---@param opts table|nil Options to open todo-comments.
    ---@return nil
    local function open_tdc(opts)
      opts = opts or {}
      local only_todos = opts.only_todos or false
      local opener = opts.opener or "Telescope"

      local cmd
      if opener == "Trouble" then
        if package.loaded.trouble == nil then -- Load Trouble if not already loaded
          require("trouble")
        end
        cmd = "TodoTrouble"
      else
        if package.loaded.telescope == nil then -- Load Telescope if not already loaded
          require("telescope")
        end
        cmd = "TodoTelescope previewer=false"
      end
      if only_todos then
        cmd = cmd .. " keywords=TODO"
      end
      if vim.bo.filetype == "oil" then
        cmd = cmd .. " cwd=" .. package.loaded.oil.get_current_dir() -- Oil is already loaded if in an Oil buffer
      end

      vim.cmd(cmd)
    end

    return {
      { "<leader>ft", function() open_tdc({ only_todos = true }) end, desc = "[F]ind: [T]odo-comments (only TODOs)" },
      { "<leader>fT", function() open_tdc() end, desc = "[F]ind: [T]odo-comments (all)" },
      {
        "<leader>xt",
        function() open_tdc({ opener = "Trouble", only_todos = true }) end,
        desc = "Trouble: [T]odo-comments (only TODOs)",
      },
      { "<leader>xT", function() open_tdc({ opener = "Trouble" }) end, desc = "Trouble: [T]odo-comments (all)" },
    }
  end,
  opts = {
    -- Include hidden files when searching for todo comments
    search = { args = { "--color=never", "--no-heading", "--with-filename", "--line-number", "--column", "--hidden" } },
  },
  config = function(_, opts)
    local tdc = require("todo-comments")

    local utils = require("utils")

    tdc.setup(opts)

    utils.keymap.set_move_pair({ "[t", "]t" }, {
      tdc.jump_next,
      tdc.jump_prev,
    }, { { desc = "Next todo-comment" }, { desc = "Previous todo-comment" } })
  end,
}
