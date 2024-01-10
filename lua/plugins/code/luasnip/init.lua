-- LuaSnip
--
-- Snippet Engine for Neovim written in Lua.

return {
  "L3MON4D3/LuaSnip",
  dependencies = {
    -- The following dependencies are needed but don't need to be loaded when the plugin is loaded
    -- "nvim-treesitter/nvim-treesitter",
    -- "numToStr/Comment.nvim",
  },
  version = "v2.*",
  keys = {
    {
      "<C-l>",
      function()
        local ls = require("luasnip")
        ls.jump(1)
      end,
      mode = { "i", "s" },
      desc = "Move to next snippet node",
    },
    {
      "<C-h>",
      function()
        local ls = require("luasnip")
        ls.jump(-1)
      end,
      mode = { "i", "s" },
      desc = "Move to previous snippet node",
    },
    {
      "<C-j>",
      function()
        local ls = require("luasnip")
        if ls.choice_active() then
          ls.change_choice(1)
        end
      end,
      mode = { "i", "s" },
      desc = "Next snippet choice option",
    },
    {
      "<C-k>",
      function()
        local ls = require("luasnip")
        if ls.choice_active() then
          ls.change_choice(-1)
        end
      end,
      mode = { "i", "s" },
      desc = "Previous snippet choice option",
    },
  },
  opts = {},
  config = function(_, opts)
    require("luasnip").setup(opts)

    local ft_to_snippets = require("plugins.code.luasnip.snippets")
    for ft, snippets in pairs(ft_to_snippets) do
      require("luasnip").add_snippets(ft, snippets)
    end
  end,
}
