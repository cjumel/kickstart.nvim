-- nvim-cmp
--
-- nvim-cmp is a lightweight and extensible completion engine for Neovim written in Lua. It is very easy to use, and
-- integrates well with many tools, like LSP or code snippets. A must-have for Neovim, in my opinion.

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
    local ls = require("luasnip")

    cmp.setup({
      snippet = { expand = function(args) ls.lsp_expand(args.body) end },
      completion = { completeopt = "menu,menuone,noinsert" }, -- Directly select the first sugggestion
      window = { completion = cmp.config.window.bordered(), documentation = cmp.config.window.bordered() },
      mapping = {
        -- <C-c> is mapped to `cmp.abort` and other things in the general keymaps
        ["<C-y>"] = cmp.mapping(cmp.mapping.confirm({ select = true }), { "i", "c" }),
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
        ["Ï"] = cmp.mapping(cmp.mapping.scroll_docs(5), { "i", "c" }), -- <M-j>
        ["È"] = cmp.mapping(cmp.mapping.scroll_docs(-5), { "i", "c" }), -- <M-k>
      },
      -- We can define groups of sources with `cmp.config.sources`: a group of sources is only enabled if the previous
      -- groups didn't return any completion items, and within a group, sources are ordered by decreasing priority,
      -- just like the usual setup
      sources = cmp.config.sources({
        { name = "luasnip" },
        { name = "nvim_lsp" },
        { name = "path" },
      }, {
        { name = "buffer" },
      }),
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
    cmp.setup.cmdline(":", {
      -- Don't show cmdline completion when path's are available to avoid duplicates
      sources = cmp.config.sources({
        { name = "path" },
      }, {
        { name = "cmdline" },
      }),
    })
    cmp.setup.cmdline({ "/", "?" }, { sources = {
      { name = "buffer" },
    } })

    -- Set up filetype-specific configurations
    cmp.setup.filetype("markdown", {
      sources = {
        { name = "luasnip" },
        { name = "nvim_lsp" },
        { name = "path" },
        { name = "emoji" },
        { name = "buffer" },
      },
    })
    cmp.setup.filetype({ "oil", "gitcommit", "NeogitCommitMessage" }, {
      sources = {
        { name = "luasnip" },
        { name = "buffer" },
      },
    })
  end,
}
