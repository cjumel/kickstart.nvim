-- nvim-cmp
--
-- Nvim-cmp is a lightweight and extensible completion plugin for neovim written in lua.

return {
  "hrsh7th/nvim-cmp",
  dependencies = {
    -- LSP completion source
    "hrsh7th/cmp-nvim-lsp",
    -- Snippets completion source
    "saadparwaiz1/cmp_luasnip",
    "L3MON4D3/LuaSnip",
    -- Other completion sources
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-cmdline",
    "hrsh7th/cmp-path",
    "clementjumel/cmp-gitmoji",
    -- Other
    "windwp/nvim-autopairs",
  },
  event = "VeryLazy",
  config = function()
    local cmp = require("cmp")
    local cmp_autopairs = require("nvim-autopairs.completion.cmp")

    cmp.setup({
      snippet = {
        expand = function(args)
          require("luasnip").lsp_expand(args.body)
        end,
      },
      window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
      },
      mapping = cmp.mapping.preset.insert({
        ["<CR>"] = cmp.mapping.confirm({ select = true }),
        ["<C-n>"] = cmp.mapping.select_next_item(),
        ["<C-p>"] = cmp.mapping.select_prev_item(),
        ["<C-s>"] = cmp.mapping.complete({}), -- suggest
        ["<C-c>"] = cmp.mapping.abort(),
        ["<C-f>"] = cmp.mapping.scroll_docs(4), -- forward documentation
        ["<C-b>"] = cmp.mapping.scroll_docs(-4), -- backward documentation
      }),
      -- Sources are grouped by decreasing priority
      sources = cmp.config.sources({
        { name = "luasnip", priority = 2 },
        { name = "nvim_lsp", priority = 1 },
      }, {
        { name = "buffer" },
      }),
    })

    -- Set configuration for specific filetypes
    cmp.setup.filetype({ "gitcommit", "NeogitCommitMessage" }, {
      sources = cmp.config.sources({
        { name = "gitmoji" },
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

    -- Insert `(` when selecting a function or method item
    cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
  end,
}
