-- nvim-cmp
--
-- Nvim-cmp is a lightweight and extensible completion engine for Neovim written in Lua. It is very easy to use, and
-- integrates well with many tools, like LSP or code snippets.

return {
  "hrsh7th/nvim-cmp",
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-cmdline",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-emoji",
    "saadparwaiz1/cmp_luasnip",
    "L3MON4D3/LuaSnip",
  },
  event = { "InsertEnter", "CmdlineEnter" }, -- CmdlineEnter is not covered by InsertEnter
  config = function()
    local cmp = require("cmp")
    local luasnip = require("luasnip")

    cmp.setup({
      snippet = { expand = function(args) luasnip.lsp_expand(args.body) end },
      window = { completion = cmp.config.window.bordered(), documentation = cmp.config.window.bordered() },
      mapping = {
        -- By default, mappings are in insert mode
        -- Using `cmp.mapping(..., { "i", "c" })` makes them available in command mode for instance
        -- <C-c> to abort completion is defined at the configuration-level
        ["<CR>"] = cmp.mapping(
          cmp.mapping.confirm({
            -- Don't automatically select an item when confirming
            -- This is really annoying in command mode (requires to press enter twice to enter a command), & I simply
            -- prefer not to use it in insert mode as well, to only trigger completion willingly
            select = false,
          }),
          { "i", "c" }
        ),
        ["<C-n>"] = cmp.mapping(function()
          if cmp.visible() then
            cmp.select_next_item()
          else
            cmp.complete()
          end
        end, { "i", "c" }),
        ["<C-p>"] = cmp.mapping(function()
          if cmp.visible() then
            cmp.select_prev_item()
          else
            cmp.complete()
          end
        end, { "i", "c" }),
        ["<C-d>"] = cmp.mapping.scroll_docs(5),
        ["<C-u>"] = cmp.mapping.scroll_docs(-5),
      },
      sources = {
        { name = "luasnip", priority = 100 },
        { name = "nvim_lsp", priority = 10 },
        { name = "buffer" },
        { name = "path" },
      },
      -- Disable menu in completion window
      -- This menu can describe the source of the completion item (e.g. its global source like "LSP" or "Luasnip", or
      -- the module corresponding to a completion item for languages like Python), however disabling it solves an issue
      -- with the documentation window hiding the completion item (see https://github.com/hrsh7th/nvim-cmp/issues/1154
      -- or https://github.com/hrsh7th/nvim-cmp/issues/1673).
      formatting = {
        format = function(_, vim_item)
          vim_item.menu = nil
          return vim_item
        end,
      },
    })

    -- Set up special configurations
    cmp.setup.cmdline(":", { sources = { { name = "cmdline" }, { name = "path" } } })
    cmp.setup.cmdline({ "/", "?" }, { sources = { { name = "buffer" } } })

    -- Set up filetype-specific configurations
    cmp.setup.filetype("markdown", {
      sources = {
        { name = "luasnip", priority = 100 },
        { name = "nvim_lsp", priority = 10 },
        { name = "buffer" },
        { name = "path" },
        { name = "emoji" },
      },
    })
    cmp.setup.filetype({ "oil", "gitcommit", "NeogitCommitMessage" }, {
      sources = {
        { name = "luasnip", priority = 100 },
        { name = "buffer" },
      },
    })
  end,
}
