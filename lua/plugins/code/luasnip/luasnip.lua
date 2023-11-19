-- LuaSnip
--
-- Snippet Engine for Neovim written in Lua.

return {
  "L3MON4D3/LuaSnip",
  version = "v2.*",
  dependencies = {
    "rafamadriz/friendly-snippets",
  },
  keys = {
    {
      "<C-y>",
      function()
        require("luasnip").jump(1)
      end,
      mode = { "i", "s" },
      desc = "Accept snippet placeholder and jump to next one",
    },
  },
  config = function()
    -- Load existing VS Code style snippets from plugins (eg. fom rafamadriz/friendly-snippets)
    require("luasnip.loaders.from_vscode").lazy_load()
  end,
}
