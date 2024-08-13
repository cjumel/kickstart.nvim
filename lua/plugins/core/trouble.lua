-- Trouble
--
-- Trouble provides pretty lists for showing diagnostics, references, telescope results, quickfix lists, etc., to help
-- you solve all the trouble your code is causing. The user interface it provides is very nice and integrates with many
-- other tools, making it a very useful plugin in many situations.

return {
  "folke/trouble.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  cmd = { "Trouble" }, -- Useful for other plugins calling Trouble through a command
  keys = {
    { "<leader>xx", "<cmd>Trouble diagnostics toggle<CR>", desc = "Trouble: diagnostics" },
    { "<leader>xl", "<cmd>Trouble loclist toggle<CR>", desc = "Trouble: [L]ocation list" },
    { "<leader>xq", "<cmd>Trouble qflist toggle<CR>", desc = "Trouble: [Q]uickfix list" },
  },
  opts = {
    focus = true, -- Focus the Trouble window when opened by default
    modes = {
      diagnostics = {
        focus = false, -- Don't focus the Trouble window when opened
        open_no_results = true, -- Open the Trouble window even when there is no item as they can appear dynamically
        filter = { buf = 0 }, -- List items from the current buffer only
      },
      lsp_references = {
        auto_refresh = false, -- Don't re-compute references when cursor moves in the main window
      },
      symbols = {
        focus = false, -- Don't focus the Trouble window when opened
        open_no_results = true, -- Open the Trouble window even when there is no item as they can appear dynamically
      },
    },
  },
}
