-- Neorg
--
-- Modernity meets insane extensibility. The future of organizing your life in Neovim.

return {
  "nvim-neorg/neorg",
  build = ":Neorg sync-parsers",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  ft = { "norg" },
  opts = {
    load = {
      ["core.defaults"] = {}, -- Loads default behaviour
      ["core.concealer"] = {}, -- Adds pretty icons to your documents
    },
  },
}
