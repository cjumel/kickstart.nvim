-- nvim-treesitter-context
--
-- A simple plugin to show code context using treesitter. I don't use this by default, but it can be very handy when
-- exploring large unknown files.

return {
  "nvim-treesitter/nvim-treesitter-context",
  lazy = true, -- Lazy-loaded when enabled from the option manager
  opts = {},
  config = function(_, opts)
    local treesitter_context = require("treesitter-context")
    treesitter_context.setup(opts)

    vim.keymap.set("n", "gC", function()
      if treesitter_context.enabled() then -- When treesitter-context is not enabled, the plugin doesn't work well
        treesitter_context.go_to_context()
      end
    end, { desc = "Go to context" })
  end,
}
