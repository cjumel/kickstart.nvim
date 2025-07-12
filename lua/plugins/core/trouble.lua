-- trouble.nvim
--
-- A pretty diagnostics, references, telescope results, quickfix and location list to help you solve all the trouble
-- your code is causing.

local todo_comment_keywords = require("plugins.core.todo-comments.keywords")

return {
  "folke/trouble.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  cmd = { "Trouble" }, -- Useful for other plugins calling Trouble through a command
  keys = {
    { "<leader>vd", "<cmd>Trouble diagnostics_document toggle<CR>", desc = "[V]iew: [D]iagnostics" },
    { "<leader>vw", "<cmd>Trouble diagnostics toggle<CR>", desc = "[V]iew: [W]orkspace diagnostics" },
    { "<leader>vl", "<cmd>Trouble loclist toggle<CR>", desc = "[V]iew: [L]ocation list" },
    { "<leader>vq", "<cmd>Trouble qflist toggle<CR>", desc = "[V]iew: [Q]uickfix list" },
    { "<leader>vs", "<cmd>Trouble symbols toggle<CR>", desc = "[V]iew: [S]ymbols" },
  },
  opts = {
    keys = {
      ["<Tab>"] = "fold_toggle",
      ["d"] = { action = "delete", mode = { "n", "v" } },
      [","] = "next",
      [";"] = "prev",
    },
    modes = {
      -- Builtin sources
      diagnostics = {
        title = "{hl:Title}Workspace Diagnostics{hl} {count}", -- Add a title
      },
      diagnostics_document = {
        mode = "diagnostics",
        title = "{hl:Title}Document Diagnostics{hl} {count}", -- Add a title
        filter = { buf = 0 }, -- Filter current buffer items only
        groups = {}, -- Remove the groups as there is only one
      },
      loclist = {
        title = "{hl:Title}Location list{hl} {count}", -- Add a title
        focus = true, -- Focus the Trouble window when opened
      },
      qflist = {
        title = "{hl:Title}Quickfix list{hl} {count}", -- Add a title
        focus = true, -- Focus the Trouble window when opened
      },

      -- LSP (see here and nvim-lspconfig)
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
        title = "{hl:Title}Symbols{hl} {count}",
        pinned = true, -- Don't update when changing window
        win = { relative = "win" }, -- Position relatively to the current window
        open_no_results = true, -- Open the Trouble window even when there is no item as the LSP can be slow
        groups = {}, -- Remove groups as there is only one
        format = "{kind_icon} {symbol.name}", -- Simplify the displayed information
      },

      -- Todo-comments (see todo-comments.nvim)
      todo = {
        title = "{hl:Title}Todo-comments {hl} {count}",
        filter = { tag = todo_comment_keywords.todo },
      },
      todo_note = {
        mode = "todo",
        title = "{hl:Title}Note-comments {hl} {count}",
        filter = { tag = todo_comment_keywords.note },
      },
      todo_private = {
        mode = "todo",
        title = "{hl:Title}Private todo-comments {hl} {count}",
        filter = { tag = todo_comment_keywords.private_todo },
      },
    },
  },
}
