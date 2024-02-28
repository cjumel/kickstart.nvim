-- telescope-undo.nvim
--
-- Visualize your undo tree and fuzzy-search changes in it.

return {
  "debugloop/telescope-undo.nvim",
  dependencies = {
    "nvim-telescope/telescope.nvim",
  },
  keys = {
    {
      "<leader>fu",
      function()
        require("telescope").extensions.undo.undo()
      end,
      desc = "[F]ind: [U]ndo tree",
    },
  },
  config = function()
    local telescope = require("telescope")
    local undo_actions = require("telescope-undo.actions")

    telescope.setup({
      extensions = {
        undo = {
          diff_context_lines = 3,
          layout_strategy = "vertical",
          mappings = {
            i = {
              ["<CR>"] = undo_actions.restore,
              ["<C-a>"] = undo_actions.yank_additions,
              ["<C-d>"] = undo_actions.yank_deletions,
            },
            n = {
              ["<CR>"] = undo_actions.restore,
              ["<C-a>"] = undo_actions.yank_additions,
              ["<C-d>"] = undo_actions.yank_deletions,
            },
          },
        },
      },
    })

    telescope.load_extension("undo")
  end,
}
