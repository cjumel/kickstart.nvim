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
        local telescope = require("telescope")

        local custom_utils = require("utils")

        local opts = {}
        if custom_utils.visual.is_visual_mode() then
          opts.default_text = custom_utils.visual.get_text()
        end

        telescope.extensions.undo.undo(opts)
      end,
      mode = { "n", "v" },
      desc = "[F]ind: [U]ndo tree",
    },
  },
  opts = {
    diff_context_lines = 5,
    mappings = {
      i = { -- Let's not overwrite potentially useful keymaps like <C-a>, <C-d>, <C-r> or <C-u>
        ["<CR>"] = function(bufnr) return require("telescope-undo.actions").yank_additions(bufnr) end,
        ["<C-y>"] = function(bufnr) return require("telescope-undo.actions").yank_deletions(bufnr) end,
        -- Disable default keymaps
        ["<S-cr>"] = false,
        ["<C-cr>"] = false,
        ["<C-r>"] = false,
      },
      n = { -- Let's just disable default keymaps as I simply don't use this mode
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
