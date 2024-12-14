-- Trouble
--
-- Trouble provides pretty lists for showing diagnostics, references, telescope results, quickfix lists, etc., to help
-- you solve all the trouble your code is causing. With a very cool and customizable user interface and the
-- integratation of many other tools (like the Todo Comments plugins), it is very complementary with telescope.nvim.

return {
  "folke/trouble.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  cmd = { "Trouble" }, -- Useful for other plugins calling Trouble through a command
  keys = {
    { "<leader>vd", "<cmd>Trouble diagnostics_document toggle<CR>", desc = "[V]iew: [D]iagnostics (document)" },
    { "<leader>vw", "<cmd>Trouble diagnostics toggle<CR>", desc = "[V]iew: [W]orspace diagnostics" },
    { "<leader>vl", "<cmd>Trouble loclist toggle<CR>", desc = "[V]iew: [L]ocation list" },
    { "<leader>vq", "<cmd>Trouble qflist toggle<CR>", desc = "[V]iew: [Q]uickfix list" },
  },
  opts = {
    keys = {
      ["<Tab>"] = "jump",
      [","] = "next",
      [";"] = "prev",
    },
    modes = {
      -- Builtin modes
      diagnostics = {
        title = "{hl:Title}Workspace Diagnostics{hl} {count}",
        open_no_results = true, -- Open the Trouble window even when there is no item as they can appear dynamically
      },
      diagnostics_document = {
        mode = "diagnostics",
        title = "{hl:Title}Document Diagnostics{hl} {count}",
        filter = { buf = 0 }, -- List items from the current buffer only
        groups = {}, -- Remove groups as this mode includes only current buffer items
      },
      loclist = {
        title = "{hl:Title}Location list{hl} {count}",
        focus = true, -- Focus the Trouble window when opened
      },
      qflist = {
        title = "{hl:Title}Quickfix list{hl} {count}",
        focus = true, -- Focus the Trouble window when opened
      },

      -- LSP modes (see nvim-lspconfig)
      lsp_definitions = {
        focus = true, -- Focus the Trouble window when opened
        auto_refresh = false, -- Don't re-compute definitions when cursor moves in the main window
      },
      lsp_type_definitions = {
        focus = true, -- Focus the Trouble window when opened
        auto_refresh = false, -- Don't re-compute type definitions when cursor moves in the main window
      },
      lsp_references = {
        focus = true, -- Focus the Trouble window when opened
        auto_refresh = false, -- Don't re-compute references when cursor moves in the main window
      },

      -- Todo-Comment modes (see todo-comments.nvim)
      todo = {
        open_no_results = true, -- Open the Trouble window even when there is no item as they can appear dynamically
        mode = "todo",
        title = "{hl:Title}Todo-comments{hl} {count}",
      },
      todo_now = {
        mode = "todo",
        title = "{hl:Title}Now todo-comments{hl} {count}",
        filter = { tag = { "NOW" } },
        groups = { { "filename", format = "{file_icon} {filename} {count}" } }, -- Remove tag group as we only have one
      },
    },
  },
}
