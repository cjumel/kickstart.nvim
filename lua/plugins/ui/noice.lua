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
      { "<leader>ah", function() noice.cmd("history") end, desc = "[A]ctions: view message [H]istory" },
      { "<leader>al", function() noice.cmd("last") end, desc = "[A]ctions: view [L]ast message" },
      { "<leader>ae", function() noice.cmd("errors") end, desc = "[A]ctions: view [E]rrors" },
    }
  end,
  opts = {
    lsp = {
      override = { -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
        ["vim.lsp.util.stylize_markdown"] = true,
        ["cmp.entry.get_documentation"] = true,
      },
    },
    presets = {
      lsp_doc_border = true, -- add a border to hover docs and signature help
      bottom_search = true, -- decreases the clutter on the screen during incremental search
    },
    routes = {
      { -- hide written messages
        filter = {
          event = "msg_show",
          kind = "",
          find = "written",
        },
        opts = { skip = true },
      },
    },
    commands = {
      history = {},
      -- Force split views when not the default because popup view doesn't work well with the custom clear window action
      last = { view = "split" },
      errors = { view = "split" },
    },
  },
}
