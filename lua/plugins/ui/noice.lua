-- Noice
--
-- Highly experimental plugin that completely replaces the UI for messages, cmdline and the
-- popupmenu.

return {
  "folke/noice.nvim",
  dependencies = {
    "MunifTanjim/nui.nvim",
    "rcarriga/nvim-notify",
    "nvim-treesitter/nvim-treesitter",
  },
  event = "VeryLazy",
  keys = {
    {
      "<leader>nh",
      function()
        require("noice").cmd("history")
      end,
      desc = "[N]oice: [H]istory",
    },
    {
      "<leader>nl",
      function()
        require("noice").cmd("last")
      end,
      desc = "[N]oice: [L]ast",
    },
    {
      "<leader>ne",
      function()
        require("noice").cmd("errors")
      end,
      desc = "[N]oice: [E]rrors",
    },
  },
  opts = {
    lsp = {
      -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
      override = {
        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
        ["vim.lsp.util.stylize_markdown"] = true,
        ["cmp.entry.get_documentation"] = true,
      },
    },
    presets = {
      lsp_doc_border = true, -- add a border to hover docs and signature help
    },
    routes = {
      -- hide written messages
      {
        filter = {
          event = "msg_show",
          kind = "",
          find = "written",
        },
        opts = { skip = true },
      },
    },
    commands = {
      history = {
        filter_opts = { reverse = true }, -- Last items first
      },
      last = {
        view = "split", -- Force split view because popup view doesn't work well the custom <ESC>
      },
      errors = {
        view = "split", -- Force split view because popup view doesn't work well the custom <ESC>
      },
    },
  },
}
