-- LuaSnip
--
-- Luasnip is a snippet Engine for Neovim. It is very easy to use and configure, and has a lot of powerful features like
-- choice, dynamic or repeat nodes, making possible to add custom logic to snippets. Overall, it makes really great the
-- experience of creating heavily customized snippets, like smart docstrings, to generic todo-comment snippets.

return {
  "L3MON4D3/LuaSnip",
  dependencies = { "saadparwaiz1/cmp_luasnip" },
  version = "v2.*",
  event = { "InsertEnter" },
  opts = {},
  config = function(_, opts)
    local ls = require("luasnip")
    ls.setup(opts)

    -- Lazy load custom snippets
    local ls_lua_loader = require("luasnip.loaders.from_lua")
    ls_lua_loader.lazy_load({ paths = { vim.fn.stdpath("config") .. "/lua/plugins/core/luasnip/snippets" } })

    vim.keymap.set({ "i", "s" }, "<C-l>", function() ls.jump(1) end, { desc = "Move to next snippet node" })
    vim.keymap.set({ "i", "s" }, "<C-h>", function() ls.jump(-1) end, { desc = "Move to previous snippet node" })
    vim.keymap.set({ "i", "s" }, "<C-j>", function()
      if ls.choice_active() then
        ls.change_choice(1)
      end
    end, { desc = "Next snippet choice option" })
    vim.keymap.set({ "i", "s" }, "<C-k>", function()
      if ls.choice_active() then
        ls.change_choice(-1)
      end
    end, { desc = "Previous snippet choice option" })
  end,
}
