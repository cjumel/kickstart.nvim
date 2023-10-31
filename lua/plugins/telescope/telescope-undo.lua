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
          initial_mode = "normal",
          mappings = {
            i = {
              ["<cr>"] = require("telescope-undo.actions").yank_additions,
            },
            n = {
              ["<cr>"] = require("telescope-undo.actions").yank_additions,
              ["="] = require("telescope-undo.actions").yank_additions,
              ["<bs>"] = require("telescope-undo.actions").yank_deletions,
            },
          },
        },
      },
    })
    require("telescope").load_extension("undo")
  end,
}
