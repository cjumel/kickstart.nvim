-- nvim-cmp
--
-- Nvim-cmp is a lightweight and extensible completion plugin for neovim written in lua.

return {
  "hrsh7th/nvim-cmp",
  dependencies = {
    -- LSP
    "hrsh7th/cmp-nvim-lsp",
    -- Snippets
    "saadparwaiz1/cmp_luasnip",
    "L3MON4D3/LuaSnip", -- Snippets engine
    "rafamadriz/friendly-snippets", -- Collection of snippets
    -- Buffer words based completion
    "hrsh7th/cmp-buffer",
  },
  event = { "BufNewFile", "BufReadPre" },
  config = function()
    local cmp = require("cmp")
    local ls = require("luasnip")

    -- Load existing VS Code style snippets from plugins (eg. fom rafamadriz/friendly-snippets)
    require("luasnip.loaders.from_vscode").lazy_load()
    -- Keymap for snippets
    vim.keymap.set({ "i", "s" }, "<C-y>", function()
      ls.jump(1)
    end, { silent = true, desc = "Accept snippet placeholder and jump to next one" })

    cmp.setup({
      snippet = {
        expand = function(args)
          ls.lsp_expand(args.body)
        end,
      },
      mapping = cmp.mapping.preset.insert({
        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-c>"] = cmp.mapping.complete({}),
        ["<CR>"] = cmp.mapping.confirm({
          behavior = cmp.ConfirmBehavior.Replace, -- When completing within a word, replace it
          select = true,
        }),
        ["<C-n>"] = cmp.mapping.select_next_item(),
        ["<C-p>"] = cmp.mapping.select_prev_item(),
      }),
      -- Sources are grouped by decreasing priority
      sources = cmp.config.sources({
        { name = "nvim_lsp", keyword_length = 2 },
        { name = "luasnip", keyword_length = 2 },
      }, {
        { name = "buffer", keyword_length = 2 },
      }),
    })
  end,
}
