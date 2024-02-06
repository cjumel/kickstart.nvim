-- Noice
--
-- Highly experimental plugin that completely replaces the UI for messages, cmdline and the
-- popupmenu.

return {
  "folke/noice.nvim",
  event = "VeryLazy",
  dependencies = {
    "MunifTanjim/nui.nvim",
    "rcarriga/nvim-notify",
    "nvim-treesitter/nvim-treesitter",
  },
  keys = {
    {
      "<ESC>",
      function()
        vim.cmd("Noice dismiss")
      end,
      desc = "Clear Noice elements",
    },
    {
      "<C-c>",
      function()
        vim.cmd("Noice dismiss")
      end,
      mode = { "n", "i", "v" },
      desc = "Clear Noice elements",
    },
    {
      "<leader>n",
      "<cmd> Noice <CR>",
      desc = "[N]otification history",
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
  },
}
