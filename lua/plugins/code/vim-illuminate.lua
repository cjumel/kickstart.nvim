-- vim-illuminate
--
-- Vim plugin for automatically highlighting other uses of the word under the cursor using either
-- LSP, Tree-sitter, or regex matching.

return {
  "RRethy/vim-illuminate",
  lazy = true,
  opts = {
    providers = { "lsp" }, -- Only enable LSP to decrease false positives
  },
  config = function(_, opts)
    require("illuminate").configure(opts)
  end,
}
