-- blink.cmp
--
-- Performant, batteries-included completion plugin for Neovim.

return {
  "saghen/blink.cmp",
  version = "1.*",
  event = { "InsertEnter", "CmdlineEnter" },
  opts = {
    keymap = {
      preset = nil,
      ["<C-n>"] = { "select_next", "show" },
      ["<C-p>"] = { "select_prev", "show" },
      ["<C-y>"] = { "accept" },
      ["<C-c>"] = { "hide", "fallback" },
    },
    completion = { documentation = { auto_show = true } },
    cmdline = {
      keymap = { preset = "inherit" },
      completion = { menu = { auto_show = true }, ghost_text = { enabled = false } },
    },
    snippets = {
      preset = "luasnip",
      score_offset = 5, -- Just above LSP
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
