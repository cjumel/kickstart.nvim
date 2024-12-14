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
    "folke/snacks.nvim",
  },
  event = "VeryLazy",
  opts = {
    lsp = {
      override = { -- Override markdown rendering so that cmp and other plugins use Treesitter
        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
        ["vim.lsp.util.stylize_markdown"] = true,
        ["cmp.entry.get_documentation"] = true,
      },
      -- Hide "No information available" LSP messages (don't bring much information & when 2 LSPs are attached, e.g.
      -- in Python with Pyright & Ruff, the message is always shown because Ruff doesn't provide any information)
      hover = { silent = true },
      signature = { enabled = false }, -- Disable Noice's signature feature in favor of lsp_signature.nvim
    },
    presets = {
      bottom_search = true, -- Move the search command at the bottom (decreases visual clutter on screen)
      lsp_doc_border = true, -- Add a border to hover documentations and signature help
      inc_rename = true, -- Enable an input dialog for inc-rename.nvim
    },
  },
}
