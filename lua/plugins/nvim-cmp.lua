-- nvim-cmp
--
-- Nvim-cmp is a lightweight and extensible completion plugin for neovim written in lua.

return {
  -- Autocompletion
  "hrsh7th/nvim-cmp",
  ft = {
    "dockerfile",
    "lua",
    "markdown",
    "python",
    "yaml", -- For docker-compose.yml
  },
  dependencies = {
    -- Adds LSP completion capabilities
    "hrsh7th/cmp-nvim-lsp",

    -- Snippet Engine & its associated nvim-cmp source
    "L3MON4D3/LuaSnip",
    "saadparwaiz1/cmp_luasnip",

    -- Add snippets
    "rafamadriz/friendly-snippets",
  },
  config = function()
    local cmp = require("cmp")
    local ls = require("luasnip")
    local ls_from_vscode_loader = require("luasnip.loaders.from_vscode")
    local s = ls.snippet
    local t = ls.text_node

    -- Use existing VS Code style snippets from a plugin (eg. rafamadriz/friendly-snippets)
    ls_from_vscode_loader.lazy_load()

    -- Add custom snippets
    ls.add_snippets("all", {
      s("todo", { t("TODO: ") }),
    })

    ls.config.setup({})

    cmp.setup({
      snippet = {
        expand = function(args)
          ls.lsp_expand(args.body)
        end,
      },
      mapping = cmp.mapping.preset.insert({
        ["<C-o>"] = cmp.mapping.complete({}),
        ["<CR>"] = cmp.mapping.confirm({
          behavior = cmp.ConfirmBehavior.Replace,
          select = true,
        }),
        ["<C-n>"] = cmp.mapping.select_next_item(),
        ["<C-p>"] = cmp.mapping.select_prev_item(),
        ["<C-d>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
      }),
      sources = {
        { name = "nvim_lsp" },
        { name = "luasnip" },
      },
    })
  end,
}
