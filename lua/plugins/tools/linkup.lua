-- linkup.nvim
--
-- Integrate the Linkup API directly in Neovim. The Linkup API provides access to LLM-augmented web search wich
-- additional access to Linkup premium sources.

return {
  "cjumel/linkup.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  init = function()
    vim.api.nvim_create_user_command(
      "LinkupStandardSearch",
      function() require("linkup").standard_search() end,
      { desc = "Run a Linkup API standard search" }
    )
    vim.api.nvim_create_user_command(
      "LinkupDeepSearch",
      function() require("linkup").deep_search() end,
      { desc = "Run a Linkup API deep search" }
    )
    vim.api.nvim_create_user_command(
      "LinkupOpenWebiste",
      function() require("linkup").open_website() end,
      { desc = "Open a website with Linkup API" }
    )
  end,
  opts = {},
}
