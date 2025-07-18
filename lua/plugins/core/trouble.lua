-- trouble.nvim
--
-- A pretty diagnostics, references, telescope results, quickfix and location list to help you solve all the trouble
-- your code is causing.

local todo_comment_keywords = require("plugins.core.todo-comments.keywords")

return {
  "folke/trouble.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  cmd = { "Trouble" }, -- For other plugins calling trouble.nvim through a command
  keys = {
    { "<leader>vd", "<cmd>Trouble diagnostics_document<CR>", desc = "[V]iew: [D]iagnostics" },
    { "<leader>vw", "<cmd>Trouble diagnostics<CR>", desc = "[V]iew: [W]orkspace diagnostics" },
    { "<leader>vl", "<cmd>Trouble loclist<CR>", desc = "[V]iew: [L]ocation list" },
    { "<leader>vq", "<cmd>Trouble qflist<CR>", desc = "[V]iew: [Q]uickfix list" },
    { "<leader>vs", "<cmd>Trouble symbols<CR>", desc = "[V]iew: [S]ymbols" },
  },
  opts = {
    focus = true,
    keys = {
      ["<Tab>"] = "fold_toggle",
      ["d"] = { action = "delete", mode = { "n", "v" } },
      [","] = "next",
      [";"] = "prev",
    },
    modes = {
      -- Builtin sources
      diagnostics = {
        title = "{hl:Title}Workspace Diagnostics{hl} {count}",
      },
      diagnostics_document = {
        mode = "diagnostics",
        title = "{hl:Title}Document Diagnostics{hl} {count}",
        filter = { buf = 0 }, -- Current buffer items only
        groups = {}, -- There is only one group
      },
      loclist = {
        title = "{hl:Title}Location list{hl} {count}",
      },
      qflist = {
        title = "{hl:Title}Quickfix list{hl} {count}",
      },

      -- LSP (see here and nvim-lspconfig)
      lsp_definitions = {
        auto_refresh = false, -- Don't refresh when cursor moves in the main window
      },
      lsp_type_definitions = {
        auto_refresh = false, -- Don't refresh when cursor moves in the main window
      },
      lsp_references = {
        auto_refresh = false, -- Don't refresh when cursor moves in the main window
      },
      symbols = {
        title = "{hl:Title}Symbols{hl} {count}",
        open_no_results = true, -- The LSP can be slow to compute symbols
        groups = {}, -- There is only one group
        format = "{kind_icon} {symbol.name}",
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
