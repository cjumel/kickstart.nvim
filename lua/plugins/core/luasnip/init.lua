-- LuaSnip
--
-- Snippet Engine for Neovim written in Lua.

return {
  "L3MON4D3/LuaSnip",
  version = "v2.*",
  lazy = true,
  opts = {},
  config = function(_, opts)
    local ls = require("luasnip")

    ls.setup(opts)

    ---@param lhs string
    ---@param rhs fun()
    ---@param desc string
    local map = function(lhs, rhs, desc)
      vim.keymap.set({ "i", "s" }, lhs, rhs, { desc = desc })
    end

    -- Define snippet navigation & choice keymaps
    map("<C-l>", function()
      ls.jump(1)
    end, "Move to next snippet node")
    map("<C-h>", function()
      ls.jump(-1)
    end, "Move to previous snippet node")
    map("<C-j>", function()
      if ls.choice_active() then
        ls.change_choice(1)
      end
    end, "Next snippet choice option")
    map("<C-k>", function()
      if ls.choice_active() then
        ls.change_choice(-1)
      end
    end, "Previous snippet choice option")

    -- Load custom snippets
    local ls_loader = require("luasnip.loaders.from_lua")
    ls_loader.load({ paths = { "./lua/plugins/core/luasnip/snippets" } })
  end,
}
