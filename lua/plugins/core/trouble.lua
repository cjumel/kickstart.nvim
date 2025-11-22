return {
  "folke/trouble.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  cmd = { "Trouble" }, -- For other plugins using trouble.nvim through a command
  keys = {
    { "<leader>vd", "<cmd>Trouble diagnostics<CR>", desc = "[V]iew: [D]iagnostics" },
    { "<leader>vl", "<cmd>Trouble loclist<CR>", desc = "[V]iew: [L]ocation list" },
    { "<leader>vq", "<cmd>Trouble qflist<CR>", desc = "[V]iew: [Q]uickfix list" },
    { "<leader>vs", "<cmd>Trouble symbols<CR>", desc = "[V]iew: [S]ymbols" },
  },
  opts = {
    focus = true,
    keys = {
      ["<Tab>"] = "fold_toggle",
      [";"] = "next",
      [","] = "prev",
    },
    modes = {
      diagnostics = { title = "{hl:Title}Workspace Diagnostics{hl} {count}" },
      loclist = { title = "{hl:Title}Location list{hl} {count}" },
      qflist = { title = "{hl:Title}Quickfix list{hl} {count}" },
      symbols = {
        title = "{hl:Title}Symbols{hl} {count}",
        focus = true,
        open_no_results = true, -- Results can appear after window opening
        groups = {},
        format = "{kind_icon} {symbol.name}",
      },
      -- Don't refresh trouble.nvim window when cursor moves in main window when using LSP features
      lsp_definitions = { auto_refresh = false },
      lsp_type_definitions = { auto_refresh = false },
      lsp_declarations = { auto_refresh = false },
      lsp_implementations = { auto_refresh = false },
      lsp_references = { auto_refresh = false },
    },
  },
}
