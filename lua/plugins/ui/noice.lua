-- Noice
--
-- Highly experimental plugin that completely replaces the UI for messages, cmdline and the popupmenu.

return {
  "folke/noice.nvim",
  dependencies = {
    "MunifTanjim/nui.nvim",
    "nvim-treesitter/nvim-treesitter",
    {
      "rcarriga/nvim-notify",
      opts = { background_colour = "#000000" }, -- Disable warnings with some color schemes when lacking this option
    },
  },
  event = "VeryLazy",
  keys = {
    -- When defining `keys` as a function with `noice = require("noice")` in it, Noice is not properly lazy-loaded
    { "<leader>vh", function() require("noice").cmd("history") end, desc = "[V]iew: message [H]istory" },
    { "<leader>vl", function() require("noice").cmd("last") end, desc = "[V]iew: [L]ast message" },
    { "<leader>ve", function() require("noice").cmd("errors") end, desc = "[V]iew: [E]rror messages" },
    { "<leader>va", function() require("noice").cmd("all") end, desc = "[V]iew: [A]ll messages" },
  },
  opts = {
    lsp = {
      override = { -- Override markdown rendering so that cmp and other plugins use Treesitter
        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
        ["vim.lsp.util.stylize_markdown"] = true,
        ["cmp.entry.get_documentation"] = true,
      },
      signature = { enabled = false }, -- Disable Noice's signature feature in favor of lsp_signature.nvim
    },
    presets = {
      bottom_search = true, -- Move the search command at the bottom (decreases visual clutter on screen)
      lsp_doc_border = true, -- Add a border to hover documentations and signature help
      inc_rename = true, -- Enable an input dialog for inc-rename.nvim
    },
    routes = {
      { filter = { event = "msg_show", kind = "", find = "written" }, opts = { skip = true } }, -- Hide written messages
    },
    commands = { -- Override builtin command options
      history = { view = "popup" },
      last = { view = "popup" },
      errors = { view = "popup", filter_opts = { reverse = false } },
      all = { view = "popup" },
    },
  },
}
