return {
  "saghen/blink.cmp",
  version = "*",
  event = { "CmdlineEnter" }, -- Lazy-loading on a custom `InsertEnter` event is also defined in `./plugin/autocmds.lua`
  opts = {
    keymap = {
      preset = nil,
      ["<C-n>"] = { "select_next", "fallback" },
      ["<C-p>"] = { "select_prev", "fallback" },
      ["<C-y>"] = { "accept", "show" },
      ["<C-c>"] = { "hide", "fallback" },
      ["<C-e>"] = { "fallback" },
    },
    completion = { documentation = { auto_show = true } },
    cmdline = {
      keymap = { preset = "inherit" },
      completion = { menu = { auto_show = true }, ghost_text = { enabled = false } },
    },
    snippets = {
      preset = "luasnip",
      -- score_offset = 5, -- Just above LSP
    },
    sources = {
      default = { "buffer", "lazydev", "lsp", "path", "snippets" },
      per_filetype = {
        sql = { "buffer", "dadbod" },
      },
      providers = {
        dadbod = { name = "Dadbod", module = "vim_dadbod_completion.blink" },
        path = {
          score_offset = 10,
          opts = { get_cwd = function(_) return vim.fn.getcwd() end }, -- Make relative to the cwd
        },
        lazydev = { name = "LazyDev", module = "lazydev.integrations.blink", score_offset = 100 },
      },
    },
  },
}
