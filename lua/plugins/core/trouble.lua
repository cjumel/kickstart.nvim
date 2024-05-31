-- Trouble
--
-- Trouble provides pretty lists for showing diagnostics, references, telescope results, quickfix lists, etc.,
-- to help you solve all the trouble your code is causing. It is a very nice interface for very various stuff, quite
-- complementary with Telescope and other plugins using the quickfix and loclist lists.

return {
  "folke/trouble.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  keys = {
    { "<leader>xd", "<cmd>Trouble diagnostics_buffer toggle<CR>", desc = "Trouble: [D]iagnostics" },
    { "<leader>xl", "<cmd>Trouble loclist toggle<CR>", desc = "Trouble: [L]ocation list" },
    { "<leader>xq", "<cmd>Trouble qflist toggle<CR>", desc = "Trouble: [Q]uickfix list" },
    { "<leader>xr", "<cmd>Trouble lsp_references_buffer toggle<CR>", desc = "Trouble: [R]eferences (LSP)" },
    { "<leader>xa", "<cmd>Trouble lsp toggle<CR>", desc = "Trouble: [A]ll information (LSP)" },
    { "<leader>xs", "<cmd>Trouble symbols toggle<CR>", desc = "Trouble: [S]ymbols (LSP)" },
  },
  opts = {
    focus = true, -- By default, focus the Trouble window when opening it
    modes = {
      diagnostics_buffer = {
        mode = "diagnostics", -- Inherit from builtin mode
        filter = { buf = 0 }, -- Filter to the current buffer only
      },
      lsp_references_buffer = {
        mode = "lsp_references", -- Inherit from builtin mode
        filter = { buf = 0 }, -- Filter to the current buffer only
      },
    },
  },
}
