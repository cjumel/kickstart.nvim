-- Noice
--
-- Noice is a highly experimental plugin that completely replaces the UI for messages, command line and the popup menu
-- in Neovim. It makes the whole experience of using Neovim feel more modern and, in my opinion, simply better, for
-- instance by re-locating some essential pieces of information (like the command line or the notifications) in a more
-- centered location in the screen.

return {
  "folke/noice.nvim",
  dependencies = {
    "MunifTanjim/nui.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  event = "VeryLazy",
  opts = {
    lsp = {
      override = { -- Override markdown rendering so that nvim-cmp & other plugins use Treesitter
        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
        ["vim.lsp.util.stylize_markdown"] = true,
        ["cmp.entry.get_documentation"] = true,
      },
      -- Hide annoying messages when a language server is attached but doesn't provide information, e.g. Ruff in Python
      hover = { silent = true },
    },
    presets = {
      bottom_search = true, -- Move the search command at the bottom
      lsp_doc_border = true, -- Add a border to hover documentations and signature help
    },
  },
}
