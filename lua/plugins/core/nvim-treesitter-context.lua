-- nvim-treesitter-context
--
-- A simple plugin to show code context using treesitter. I don't use this by default, but it can be very handy when
-- exploring large unknown files.

return {
  "nvim-treesitter/nvim-treesitter-context",
  -- We could lazy loaded the plugin if `vim.g.disable_treesitter_context` defaults to `false`, but for the sake of
  -- simplicity let's not bother with that
  lazy = true, -- Dependency of `nvim-treesitter`
  opts = {},
  config = function(_, opts)
    local treesitter_context = require("treesitter-context")

    opts.enable = not vim.g.disable_treesitter_context
    treesitter_context.setup(opts)

    vim.keymap.set("n", "gp", function()
      if treesitter_context.enabled() then -- When treesitter-context is not enabled, the plugin doesn't work well
        treesitter_context.go_to_context()
      end
    end, { desc = "Go to context parent node" })
  end,
}
