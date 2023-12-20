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

    local custom_select_next_item = function()
      if cmp.visible() then
        cmp.select_next_item()
      else
        cmp.complete()
      end
    end
    local custom_select_prev_item = function()
      if cmp.visible() then
        cmp.select_prev_item()
      else
        cmp.complete()
      end
    end

    cmp.setup({
      snippet = {
        expand = function(args)
          require("luasnip").lsp_expand(args.body)
        end,
      },
      completion = {
        completeopt = "menu,menuone,noinsert", -- Ensure first menu item is selected by default
      },
      window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
      },
      mapping = { -- By default, mappings are in insert mode
        ["<CR>"] = cmp.mapping.confirm(),
        ["<C-n>"] = custom_select_next_item,
        ["<C-p>"] = custom_select_prev_item,
        ["<C-c>"] = cmp.mapping.abort(),
        ["<C-f>"] = cmp.mapping.scroll_docs(5),
        ["<C-b>"] = cmp.mapping.scroll_docs(-5),
      },
      -- Sources are grouped by decreasing priority
      sources = cmp.config.sources({
        { name = "luasnip", priority = 2 },
        { name = "nvim_lsp", priority = 1 },
      }, {
        { name = "buffer" },
      }),
      -- Disable menu in completion window
      -- This menu can describe the source of the completion item (e.g. its global source like
      -- "LSP" or "Luasnip", or the module corresponding to a completion item for languages like
      -- Python), however disabling it solves an issue with the documentation window hiding the
      -- completion item (see https://github.com/hrsh7th/nvim-cmp/issues/1154 or
      -- https://github.com/hrsh7th/nvim-cmp/issues/1673).
      formatting = {
        format = function(_, vim_item)
          vim_item.menu = nil
          return vim_item
        end,
      },
    })

    -- Set configuration for specific filetypes
    cmp.setup.filetype({ "gitcommit", "NeogitCommitMessage" }, {
      sources = cmp.config.sources({
        { name = "gitmoji" },
      }, {
        { name = "buffer" },
      }),
    })

    local cmdline_mapping = { -- "c =" means command line mode
      ["<Tab>"] = { c = cmp.mapping.confirm() },
      ["<C-n>"] = { c = custom_select_next_item },
      ["<C-p>"] = { c = custom_select_prev_item },
      ["<C-c>"] = { c = cmp.mapping.abort() },
    }

    cmp.setup.cmdline({ "/", "?" }, {
      mapping = cmdline_mapping,
      sources = {
        { name = "buffer" },
      },
    })

    cmp.setup.cmdline(":", {
      mapping = cmdline_mapping,
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
