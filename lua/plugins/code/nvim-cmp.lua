-- nvim-cmp
--
-- Nvim-cmp is a lightweight and extensible completion plugin for neovim written in lua.

return {
  -- Autocompletion
  "hrsh7th/nvim-cmp",
  event = { "BufNewFile", "BufReadPre" },
  dependencies = {
    -- Adds LSP completion capabilities
    "hrsh7th/cmp-nvim-lsp",

    -- Snippet Engine & its associated nvim-cmp source
    "L3MON4D3/LuaSnip",
    "saadparwaiz1/cmp_luasnip",

    -- Add snippets
    "rafamadriz/friendly-snippets",

    -- Add buffer completion
    "hrsh7th/cmp-buffer",
  },
  config = function()
    local cmp = require("cmp")
    local ls = require("luasnip")

    -- Load existing VS Code style snippets from plugins (eg. fom rafamadriz/friendly-snippets)
    require("luasnip.loaders.from_vscode").lazy_load()

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
        { name = "buffer" },
      },
    })

    -- Snippet-related keymaps
    vim.keymap.set({ "i", "s" }, "<C-y>", function()
      ls.jump(1)
    end, { silent = true, desc = "Jump to next snippet placeholder" })
    vim.keymap.set({ "i", "s" }, "<C-e>", function()
      if ls.choice_active() then
        ls.change_choice(1)
      end
    end, { silent = true, desc = "Change snippet choice" })
  end,
}
