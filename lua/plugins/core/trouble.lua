-- Trouble
--
-- Trouble provides pretty lists for showing diagnostics, references, telescope results, quickfix lists, etc., to help
-- you solve all the trouble your code is causing. With a very cool user interface and the integratation of many other
-- tools (like the Todo comments plugins), it is very complementary with plugins like Telescope, since Telescope shines
-- with fuzzy searching and for "one-time" navigation (once we select entries, the Telescope menu disappears), while
-- Trouble is better equipped for long-term navigation of items (we can select an item while keeping the Trouble window
-- open).

return {
  "folke/trouble.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  cmd = { "Trouble" }, -- Useful for other plugins calling Trouble through a command
  keys = {
    { "<leader>xd", "<cmd>Trouble diagnostics_document toggle<CR>", desc = "Trouble: [D]iagnostics (document)" },
    { "<leader>xD", "<cmd>Trouble diagnostics toggle<CR>", desc = "Trouble: [D]iagnostics (workspace)" },
    { "<leader>xl", "<cmd>Trouble loclist toggle<CR>", desc = "Trouble: [L]ocation list" },
    { "<leader>xq", "<cmd>Trouble qflist toggle<CR>", desc = "Trouble: [Q]uickfix list" },
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
      lsp_references = {
        focus = true, -- Focus the Trouble window when opened
        auto_refresh = false, -- Don't re-compute references when cursor moves in the main window
      },
      symbols = {
        open_no_results = true, -- Open the Trouble window even when there is no item as they can appear dynamically
        groups = {}, -- Remove groups as this mode includes only current buffer items
      },
      todo = {
        title = "{hl:Title}Todo-comments{hl} {count}",
        open_no_results = true, -- Open the Trouble window even when there is no item as they can appear dynamically
      },
      todo_now = {
        mode = "todo",
        title = "{hl:Title}NOW Todo-comments{hl} {count}",
        filter = { tag = { "NOW" } }, -- Only show "NOW" todo-comments
        groups = { { "filename", format = "{file_icon} {filename} {count}" } }, -- Remove tag group as we only have one
      },
    },
  },
}
