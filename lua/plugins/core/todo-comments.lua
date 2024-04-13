-- todo-comments
--
-- Enable highlighting for todo, fixme, bug, fixit, issue & note comments.
-- This plugin can also be used as a provider for trouble.nvim.

return {
  "folke/todo-comments.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  event = { "BufNewFile", "BufReadPre" },
  keys = {
    {
      "<leader>ft",
      function()
        local oil = require("oil")
        if package.loaded.telescope == nil then
          require("telescope")
        end

        local cmd = "TodoTelescope previewer=false keywords=TODO"
        if vim.bo.filetype == "oil" then
          cmd = cmd .. " cwd=" .. oil.get_current_dir()
        end

        vim.cmd(cmd)
      end,
      desc = "[F]ind: [T]odo-comments (only TODOs)",
    },
    {
      "<leader>fT",
      function()
        local oil = require("oil")
        if package.loaded.telescope == nil then
          require("telescope")
        end

        local cmd = "TodoTelescope previewer=false"
        if vim.bo.filetype == "oil" then
          cmd = cmd .. " cwd=" .. oil.get_current_dir()
        end

        vim.cmd(cmd)
      end,
      desc = "[F]ind: [T]odo-comments (all)",
    },
  },
  opts = {
    search = {
      args = { -- Default rg command with hidden files
        "--color=never",
        "--no-heading",
        "--with-filename",
        "--line-number",
        "--column",
        "--hidden",
      },
    },
  },
  config = function(_, opts)
    local tdc = require("todo-comments")

    tdc.setup(opts)

    local utils = require("utils")
    utils.keymap.set_move_pair({ "[t", "]t" }, {
      tdc.jump_next,
      tdc.jump_prev,
    }, { { desc = "Next todo-comment" }, { desc = "Previous todo-comment" } })
  end,
}
