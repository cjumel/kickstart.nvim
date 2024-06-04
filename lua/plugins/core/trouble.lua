-- Trouble
--
-- Trouble provides pretty lists for showing diagnostics, references, telescope results, quickfix lists, etc.,
-- to help you solve all the trouble your code is causing. It is a very nice interface for very various stuff, quite
-- complementary with Telescope and other plugins using the quickfix and loclist lists.

return {
  "folke/trouble.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  keys = {
    { "<leader>xd", "<cmd>Trouble diagnostics_buffer toggle<CR>", desc = "Trouble: [D]iagnostics (buffer)" },
    { "<leader>xD", "<cmd>Trouble diagnostics toggle<CR>", desc = "Trouble: [D]iagnostics (workspace)" },
    { "<leader>xr", "<cmd>Trouble lsp_references_buffer toggle<CR>", desc = "Trouble: LSP [R]eferences (buffer)" },
    { "<leader>xR", "<cmd>Trouble lsp_references toggle<CR>", desc = "Trouble: LSP [R]eferences (workspace)" },
    { "<leader>xa", "<cmd>Trouble lsp toggle<CR>", desc = "Trouble: [A]ll LSP symbol information" },
    { "<leader>xs", "<cmd>Trouble symbols toggle<CR>", desc = "Trouble: LSP [S]ymbols" },
    { "<leader>xl", "<cmd>Trouble loclist toggle<CR>", desc = "Trouble: [L]ocation list" },
    { "<leader>xq", "<cmd>Trouble qflist toggle<CR>", desc = "Trouble: [Q]uickfix list" },
  },
  opts = {
    focus = true, -- Focus the Trouble window when opened
    modes = {
      diagnostics = {
        focus = false, -- Don't focus the Trouble window when opened
        open_no_results = true, -- Open the Trouble window even when there is no item as they can appear dynamically
      },
      diagnostics_buffer = {
        mode = "diagnostics", -- Inherit from existing mode
        filter = { buf = 0 }, -- List items from the current buffer only
      },
      lsp_references = {
        auto_refresh = false, -- Don't re-compute references when cursor moves in the main window
      },
      lsp_references_buffer = {
        mode = "lsp_references", -- Inherit from existing mode
        filter = { buf = 0 }, -- List items from the current buffer only
      },
      lsp = {
        auto_refresh = false, -- Don't re-compute references, declarations, etc. when cursor moves in the main window
      },
      symbols = {
        focus = false, -- Don't focus the Trouble window when opened
        open_no_results = true, -- Open the Trouble window even when there is no item as they can appear dynamically
      },
    },
  },
}
