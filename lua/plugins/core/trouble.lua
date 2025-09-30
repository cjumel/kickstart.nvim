return {
  "folke/trouble.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  cmd = { "Trouble" }, -- For other plugins calling trouble.nvim through a command
  keys = {
    { "<leader>vd", "<cmd>Trouble diagnostics_document<CR>", desc = "[V]iew: [D]iagnostics" },
    { "<leader>vD", "<cmd>Trouble diagnostics<CR>", desc = "[V]iew: [D]iagnostics (workspace)" },
    { "<leader>vl", "<cmd>Trouble loclist<CR>", desc = "[V]iew: [L]ocation list" },
    { "<leader>vq", "<cmd>Trouble qflist<CR>", desc = "[V]iew: [Q]uickfix list" },
    { "<leader>vs", "<cmd>Trouble symbols<CR>", desc = "[V]iew: [S]ymbols" },
  },
  opts = function()
    return {
      focus = true,
      keys = {
        ["<Tab>"] = "fold_toggle",
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
          focus = true, -- For some reason this needs to be specified again here
          open_no_results = true, -- The LSP can be slow to compute symbols
          groups = {}, -- There is only one group
          format = "{kind_icon} {symbol.name}",
        },

        -- Todo-comments (see todo-comments.nvim)
        todo = {
          title = "{hl:Title}Todo-comments {hl} {count}",
          filter = { tag = vim.g.todo_comment_keywords_todo or {} },
        },
        todo_note = {
          mode = "todo",
          title = "{hl:Title}Note-comments {hl} {count}",
          filter = { tag = vim.g.todo_comment_keywords_note or {} },
        },
        todo_private = {
          mode = "todo",
          title = "{hl:Title}Private todo-comments {hl} {count}",
          filter = { tag = vim.g.todo_comment_keywords_private or {} },
        },
      },
    }
  end,
}
