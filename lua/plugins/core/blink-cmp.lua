return {
  "saghen/blink.cmp",
  version = "*",
  event = { "CmdlineEnter" }, -- Lazy-loading on a custom `InsertEnter` event is also defined in `./plugin/autocmds.lua`
  opts = {
    keymap = {
      preset = "none",
      ["<C-n>"] = { "select_next", "fallback" },
      ["<C-p>"] = { "select_prev", "fallback" },
      ["<C-y>"] = { "accept", "show" },
      ["<C-c>"] = { "hide", "fallback" },
      ["<C-s>"] = { "show_signature", "hide_signature", "fallback" },
    },
    completion = {
      accept = { auto_brackets = { enabled = false } },
      documentation = { auto_show = true },
    },
    snippets = { preset = "luasnip" },
    sources = {
      per_filetype = {
        sql = { "dadbod", "buffer" },
        lua = { inherit_defaults = true, "lazydev" },
      },
      providers = {
        buffer = {
          opts = {
            get_bufnrs = function() -- Use all open normal buffers
              return vim.tbl_filter(function(bufnr) return vim.bo[bufnr].buftype == "" end, vim.api.nvim_list_bufs())
            end,
          },
        },
        path = {
          opts = {
            get_cwd = function() return vim.fn.getcwd() end, -- Make suggested paths relative to the cwd
          },
        },
        lazydev = { name = "LazyDev", module = "lazydev.integrations.blink", score_offset = 100 },
        dadbod = { name = "Dadbod", module = "vim_dadbod_completion.blink" },
      },
    },
    cmdline = {
      keymap = { preset = "inherit" },
      completion = {
        menu = { auto_show = true },
        ghost_text = { enabled = false },
      },
    },
    signature = { enabled = true },
  },
}
