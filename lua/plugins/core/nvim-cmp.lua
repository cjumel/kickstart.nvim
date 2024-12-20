-- nvim-cmp
--
-- nvim-cmp is a lightweight and extensible completion engine for Neovim written in Lua. It is very easy to use, and
-- integrates well with many tools, like LSP or code snippets. A must-have for Neovim, in my opinion.

local nvim_config = require("nvim_config")

return {
  "hrsh7th/nvim-cmp",
  dependencies = {
    { "hrsh7th/cmp-nvim-lsp", cond = not nvim_config.light_mode },
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
      sources = {
        { name = "luasnip" },
        { name = "nvim_lsp" },
        { name = "path" },
        { name = "buffer" },
      },
      -- Disable menu in completion window. This menu can describe the source of the completion item (e.g. its global
      --  source like "LSP" or "Luasnip", or the module corresponding to a completion item for languages like Python),
      --  however disabling it solves an issue with the documentation window hiding the completion item. See
      --  https://github.com/hrsh7th/nvim-cmp/issues/1154 or https://github.com/hrsh7th/nvim-cmp/issues/1673).
      formatting = {
        format = function(_, vim_item)
          vim_item.menu = nil
          return vim_item
        end,
      },
    })

    -- Set up special configurations
    cmp.setup.cmdline(":", {
      -- We can define groups of sources with the `group_index` source attribute or using the `cmp.config.sources`
      --  function. A group of sources is only enabled if all the previous groups didn't return any completion items,
      --  and within a group, sources are ordered by decreasing priority, just like the usual setup.
      -- Here, we don't want to show cmdline completion when path's are available to avoid duplicates between the two
      --  sources, and path completion are more user-friendly than cmdline's for paths.
      sources = {
        { name = "path", group_index = 1 },
        { name = "cmdline", group_index = 2 },
      },
    })
    cmp.setup.cmdline({ "/", "?" }, { sources = {
      { name = "buffer" },
    } })

    -- Set up filetype-specific configurations
    cmp.setup.filetype("lua", {
      sources = {
        { name = "lazydev", group_index = 0 }, -- `group_index = 0` is recommended by lazydev
        { name = "luasnip", group_index = 1 },
        { name = "nvim_lsp", group_index = 1 },
        { name = "path", group_index = 1 },
        { name = "buffer", group_index = 1 },
      },
    })
    cmp.setup.filetype("markdown", {
      sources = {
        { name = "luasnip" },
        { name = "nvim_lsp" },
        { name = "path" },
        { name = "emoji" },
        { name = "buffer" },
      },
    })
    cmp.setup.filetype({ "oil", "gitcommit" }, {
      sources = {
        { name = "luasnip" },
        { name = "buffer" },
      },
    })
  end,
}
