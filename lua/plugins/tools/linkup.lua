-- linkup.nvim
--
-- Integrate the Linkup API directly in Neovim. The Linkup API provides access to LLM-augmented web search, as well as
-- to Linkup's premium sources.

return {
  "cjumel/linkup.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  cmd = { "LinkupStandardSearch", "LinkupDeepSearch" },
  opts = {},
}
