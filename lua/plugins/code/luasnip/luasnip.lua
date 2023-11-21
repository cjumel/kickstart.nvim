-- LuaSnip
--
-- Snippet Engine for Neovim written in Lua.

return {
  "L3MON4D3/LuaSnip",
  version = "v2.*",
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
    require("luasnip").add_snippets("lua", require("plugins.code.luasnip.snippets.lua"))
    require("luasnip").add_snippets("python", require("plugins.code.luasnip.snippets.python"))
  end,
}
