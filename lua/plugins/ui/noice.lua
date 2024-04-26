-- Noice
--
-- Highly experimental plugin that completely replaces the UI for messages, cmdline and the
-- popupmenu.

return {
  "folke/noice.nvim",
  dependencies = {
    "MunifTanjim/nui.nvim",
    "nvim-treesitter/nvim-treesitter",
    {
      "rcarriga/nvim-notify",
      opts = {
        background_colour = "#000000", -- Disable warnings with some color schemes when lacking this option
      },
    },
  },
  event = "VeryLazy",
  keys = function()
    local noice = require("noice")
    return {
      { "<leader>vh", function() noice.cmd("history") end, desc = "[V]iew: message [H]istory" },
      { "<leader>vl", function() noice.cmd("last") end, desc = "[V]iew: [L]ast message" },
      { "<leader>ve", function() noice.cmd("errors") end, desc = "[V]iew: [E]rror messages" },
      { "<leader>va", function() noice.cmd("all") end, desc = "[V]iew: [A]ll messages" },
    }
  end,
  opts = {
    lsp = {
      override = { -- Override markdown rendering so that cmp and other plugins use Treesitter
        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
        ["vim.lsp.util.stylize_markdown"] = true,
        ["cmp.entry.get_documentation"] = true,
      },
    },
    presets = {
      bottom_search = true, -- Move the search command at the bottom (decreases visual clutter on screen)
      lsp_doc_border = true, -- Add a border to hover documentations and signature help
    },
    routes = {
      { filter = { event = "msg_show", kind = "", find = "written" }, opts = { skip = true } }, -- Hide written messages
    },
    commands = {
      -- Override builtin commands options
      history = { view = "popup" },
      errors = { filter_opts = { reverse = false } },
      -- Custom commands
      all = {
        view = "popup",
        opts = { enter = true, format = "details" },
        filter = {
          ["not"] = { event = "msg_show", kind = "", find = "written" }, -- Hide written messages
        },
      },
    },
  },
}
