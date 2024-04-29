-- inc-rename.nvim
--
-- Provide a command for LSP renaming with immediate visual feedback thanks to Neovim's command preview feature.
--
-- This small plugin is quite convenient to bring the advantages of incremental searching (highlightin & immediate
-- feedback) to LSP renaming, as well as making the rename prompt located at the cursor position.

return {
  "smjonas/inc-rename.nvim",
  lazy = true,
  opts = {},
}
