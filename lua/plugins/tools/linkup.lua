-- linkup.nvim
--
-- Integrate the Linkup API directly in Neovim. The Linkup API provides access to LLM-augmented web search wich
-- additional access to Linkup premium sources.

return {
  "cjumel/linkup.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  keys = {
    {
      "<leader>ls",
      function() require("linkup").standard_search() end,
      mode = { "n", "v" },
      desc = "[L]inkup: [S]tandard search",
    },
    {
      "<leader>ld",
      function() require("linkup").deep_search() end,
      mode = { "n", "v" },
      desc = "[L]inkup: [D]eep search",
    },
  },
  opts = {},
}
