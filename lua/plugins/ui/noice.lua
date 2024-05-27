-- Noice
--
-- Noice is a highly experimental plugin that completely replaces the UI for messages, command line and the popup menu.
-- It makes the whole experience of using Neovim feel more modern and, in my opinion, simply better, for instance by
-- re-locating some essential pieces of information (like the command line or the notifications) in a more convenient
-- place.

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
    -- When defining `keys` as a function with `noice = require("noice")` in it, Noice is not properly very-lazy-loaded
    { "<leader>nh", function() require("noice").cmd("history") end, desc = "[N]oice: [H]istory" },
    { "<leader>nl", function() require("noice").cmd("last") end, desc = "[N]oice: [L]ast message" },
    { "<leader>ne", function() require("noice").cmd("errors") end, desc = "[N]oice: [E]rrors" },
    { "<leader>na", function() require("noice").cmd("all") end, desc = "[N]oice: [A]ll messages" },
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
