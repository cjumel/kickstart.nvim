-- telescope-undo.nvim
--
-- telescope-undo.nvim is a Telescope extension to visualize the undotree and fuzzy-search changes in it. I don't find
-- it as convenient as the undotree plugin for simple visualization and navigation in the undotree and I've encountered
-- issues with telescope-undo.nvim to restore some past states, but it enables fuzzy-searching changes in it, which is a
-- super nice feature and makes it nicely complementary with undotree.

return {
  "debugloop/telescope-undo.nvim",
  dependencies = { "nvim-telescope/telescope.nvim" },
  keys = {
    {
      "<leader>fu",
      function()
        local telescope = require("telescope")
        local visual_mode = require("visual_mode")

        local opts = {
          -- Sort entries by recency
          tiebreak = function(current, existing, _) return current.index < existing.index end,
        }
        if visual_mode.is_on() then
          opts.default_text = visual_mode.get_text()
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
