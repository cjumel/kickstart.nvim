-- linkup.nvim
--
-- Integrate the Linkup API directly in Neovim. The Linkup API provides access to LLM-augmented web search, as well as
-- to Linkup's premium sources.

return {
  "cjumel/linkup.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  cmd = { "LinkupStandardSearch", "LinkupDeepSearch", "LinkupViewLastQuerySources", "LinkupToggleIncludeImages" },
  opts = {
    base_url = false, -- Make it overridable with environment variables
  },
}
