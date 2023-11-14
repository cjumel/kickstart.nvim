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
    -- Other
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-cmdline",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-emoji",
  },
  event = "VeryLazy",
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

    -- Set configuration for specific filetypes
    cmp.setup.filetype({ "gitcommit", "NeogitCommitMessage" }, {
      sources = cmp.config.sources({
        { name = "emoji" }, -- For gitmojis
      }, {
        { name = "buffer" },
      }),
    })

    -- Use buffer source for `/` and `?`
    cmp.setup.cmdline({ "/", "?" }, {
      mapping = cmp.mapping.preset.cmdline(),
      sources = {
        { name = "buffer" },
      },
    })

    -- Use cmdline & path source for ':'
    -- Path is redundant with cmdline, but it's easier to use for paths
    cmp.setup.cmdline(":", {
      mapping = cmp.mapping.preset.cmdline(),
      sources = cmp.config.sources({
        { name = "path" },
      }, {
        { name = "cmdline" },
      }),
    })
  end,
}
