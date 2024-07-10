-- telescope-undo.nvim
--
-- telescope-undo is a Telescope extension to visualize the undotree and fuzzy-search changes in it. I don't find it
-- as convenient as the undotree plugin for simple visualization and navigation in the undotree and I've encountered
-- issues with telescope-undo to restore some past states, but it enables fuzzy-searching changes in it, which is a
-- super nice feature and makes telescope-undo nicely complementary with undotree.

return {
  "debugloop/telescope-undo.nvim",
  dependencies = { "nvim-telescope/telescope.nvim" },
  keys = {
    {
      "<leader>fu",
      function()
        local custom_utils = require("utils")
        local telescope = require("telescope")

        local opts = {
          tiebreak = function(current, existing, _) return current.index < existing.index end, -- Sort entries by recency
        }
        if custom_utils.visual.is_visual_mode() then
          opts.default_text = custom_utils.visual.get_text()
        end
        telescope.extensions.undo.undo(opts)
      end,
      mode = { "n", "v" },
      desc = "[F]ind: [U]ndotree",
    },
  },
  opts = {
    diff_context_lines = 5, -- Number of lines to display around each change
    mappings = {
      i = {
        ["<CR>"] = function(bufnr) return require("telescope-undo.actions").yank_additions(bufnr) end,
        ["<M-CR>"] = function(bufnr) return require("telescope-undo.actions").yank_deletions(bufnr) end, -- <C-CR>
        -- Disable default plugin keymaps
        ["<S-cr>"] = false,
        ["<C-cr>"] = false,
        ["<C-y>"] = false,
        ["<C-r>"] = false,
      },
      n = {
        ["<CR>"] = function(bufnr) return require("telescope-undo.actions").yank_additions(bufnr) end,
        ["<M-CR>"] = function(bufnr) return require("telescope-undo.actions").yank_deletions(bufnr) end, -- <C-CR>
        -- Disable default plugin keymaps
        ["y"] = false,
        ["Y"] = false,
        ["u"] = false,
      },
    },
  },
  config = function(_, opts)
    local telescope = require("telescope")

    telescope.setup({ extensions = { undo = opts } })
    telescope.load_extension("undo")
  end,
}
