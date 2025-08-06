-- LuaSnip
--
-- Snippet Engine for Neovim written in Lua.

return {
  "L3MON4D3/LuaSnip",
  dependencies = { "saadparwaiz1/cmp_luasnip" },
  version = "v2.*",
  lazy = true,
  init = function() -- Setup custom lazy-loading event
    vim.api.nvim_create_autocmd("InsertEnter", {
      callback = function()
        if vim.bo.buftype == "" or vim.bo.filetype == "oil" then
          Lazy.load({ plugins = { "LuaSnip" } })
        end
      end,
    })
  end,
  opts = {},
  config = function(_, opts)
    local ls = require("luasnip")
    ls.setup(opts)

    local ls_lua_loader = require("luasnip.loaders.from_lua")
    ls_lua_loader.lazy_load({ paths = { vim.fn.stdpath("config") .. "/lua/config/snippets/snippets" } })

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
