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
    { "<leader>vd", "<cmd>Trouble diagnostics_document toggle<CR>", desc = "[V]iew: buffer [D]iagnostics" },
    { "<leader>vD", "<cmd>Trouble diagnostics toggle<CR>", desc = "[V]iew: workspace [D]iagnostics" },
    { "<leader>vl", "<cmd>Trouble loclist toggle<CR>", desc = "[V]iew: [L]ocation list" },
    { "<leader>vq", "<cmd>Trouble qflist toggle<CR>", desc = "[V]iew: [Q]uickfix list" },
    { "<leader>vs", "<cmd>Trouble symbols toggle<CR>", desc = "[V]iew: document [S]ymbols" },
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

      -- LSP (see nvim-lspconfig)
      lsp_definitions = {
        focus = true, -- Focus the Trouble window when opened
        auto_refresh = false, -- Don't refresh Trouble window when cursor moves in the main window
      },
      lsp_type_definitions = {
        focus = true, -- Focus the Trouble window when opened
        auto_refresh = false, -- Don't refresh Trouble window when cursor moves in the main window
      },
      lsp_references = {
        focus = true, -- Focus the Trouble window when opened
        auto_refresh = false, -- Don't refresh Trouble window when cursor moves in the main window
      },
      symbols = {
        open_no_results = true, -- Open the Trouble window even when there is no item as the LSP can be slow
        groups = {}, -- Remove the file name as there is only one
        format = "{kind_icon} {symbol.name}", -- Simplify the displayed information
      },

      -- Todo-comments (see todo-comments.nvim)
      todo = {
        title = "{hl:Title}Todo-comments{hl} {count}", -- Add a title
      },
      todo_now = {
        mode = "todo",
        title = "{hl:Title}Now todo-comments{hl} {count}", -- Add a title
        filter = { tag = { "NOW" } }, -- Filter todo-comment tags
        groups = { { "filename", format = "{file_icon} {filename} {count}" } }, -- Remove tag group as we only have one
      },
    },
  },
}
