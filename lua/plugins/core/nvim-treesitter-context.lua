-- nvim-treesitter-context
--
-- Use treesitter to show the context of the currently visible buffer contents.

return {
  "nvim-treesitter/nvim-treesitter-context",
  lazy = true,
  opts = {
    enable = false, -- Keep the plugin disabled by default and only enable it via keymaps
    mode = "topline",
  },
  config = function(_, opts)
    local treesitter_context = require("treesitter-context")
    treesitter_context.setup(opts)

    vim.keymap.set(
      "n",
      "<leader>,c",
      treesitter_context.toggle,
      { desc = "Settings: toggle [C]ontext" }
    )
  end,
}
