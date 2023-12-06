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
      "<leader>u",
      function()
        require("telescope").extensions.undo.undo()
      end,
      desc = "[U]ndo tree",
    },
  },
  config = function()
    require("telescope").setup({
      extensions = {
        undo = {
          diff_context_lines = 3,
          layout_strategy = "vertical",
          mappings = {
            i = {
              ["<CR>"] = require("telescope-undo.actions").restore,
              ["<C-a>"] = require("telescope-undo.actions").yank_additions,
              ["<C-d>"] = require("telescope-undo.actions").yank_deletions,
            },
            n = {
              ["<CR>"] = require("telescope-undo.actions").restore,
              ["a"] = require("telescope-undo.actions").yank_additions,
              ["d"] = require("telescope-undo.actions").yank_deletions,
            },
          },
        },
      },
    })
    require("telescope").load_extension("undo")
  end,
}
