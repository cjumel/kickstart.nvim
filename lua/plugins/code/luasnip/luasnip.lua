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
      "<C-y>",
      function()
        local ls = require("luasnip")
        ls.jump(1)
      end,
      mode = { "n", "i", "s" },
      desc = "Next snippet node",
    },
    {
      "<C-g>",
      function()
        local ls = require("luasnip")
        ls.jump(-1)
      end,
      mode = { "n", "i", "s" },
      desc = "Previous snippet node",
    },
    {
      "<C-o>", -- This keymap is okay to remap only in insert mode
      function()
        local ls = require("luasnip")
        if ls.choice_active() then
          ls.change_choice(1)
        end
      end,
      mode = { "i", "s" },
      desc = "Next snippet choice option",
    },
  },
  opts = {
    enable_autosnippets = true,
  },
  config = function(_, opts)
    require("luasnip").setup(opts)

    require("luasnip").add_snippets("all", require("plugins.code.luasnip.snippets.all"))
    require("luasnip").add_snippets("lua", require("plugins.code.luasnip.snippets.lua"))
    require("luasnip").add_snippets("python", require("plugins.code.luasnip.snippets.python"))
  end,
}
