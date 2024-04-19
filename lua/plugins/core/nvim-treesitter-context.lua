-- nvim-treesitter-context
--
-- Use treesitter to show the context of the currently visible buffer contents.

return {
  "nvim-treesitter/nvim-treesitter-context",
  lazy = true, -- Dependency of nvim-treesitter
  opts = {
    enable = false, -- Keep the plugin disabled by default and only enable it via keymaps
  },
  config = function(_, opts)
    local treesitter_context = require("treesitter-context")
    treesitter_context.setup(opts)

    -- gp is used to go to treesitter parent node
    vim.keymap.set("n", "gP", function()
      if treesitter_context.enabled() then -- When treesitter-context is not enabled, the plugin doesn't work well
        treesitter_context.go_to_context()
      end
    end, { desc = "Go to context parent node" })
  end,
}
