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
      require("plugins.core.telescope-undo.builtin").find_undotree,
      mode = { "n", "v" },
      desc = "[F]ind: [U]ndotree",
    },
  },
  opts = {
    vim_diff_opts = { ctxlen = 5 }, -- Number of lines to display around each change
    mappings = {
      i = {
        ["<CR>"] = require("plugins.core.telescope-undo.actions").yank_additions,
        ["<M-CR>"] = require("plugins.core.telescope-undo.actions").yank_deletions, -- <C-CR>
        ["<S-cr>"] = false,
        ["<C-cr>"] = false,
        ["<C-y>"] = false,
        ["<C-r>"] = false,
      },
      n = {
        ["<CR>"] = require("plugins.core.telescope-undo.actions").yank_additions,
        ["<M-CR>"] = require("plugins.core.telescope-undo.actions").yank_deletions, -- <C-CR>
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
