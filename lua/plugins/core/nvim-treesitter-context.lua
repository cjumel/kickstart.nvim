-- nvim-treesitter-context
--
-- A simple and lightweight plugin to show code context, using Treesitter. I don't use this by default as it clutters
-- the buffer view, but through keymaps instead, since it can be very handy when exploring large unknown files.

return {
  "nvim-treesitter/nvim-treesitter-context",
  event = { "BufNewFile", "BufReadPre" }, -- Lazy-loading the plugin on keys doesn't work well
  opts = {
    enable = false, -- Disable by default, can be enabled by the settings Hydra through a keymap
  },
  config = function(_, opts)
    local treesitter_context = require("treesitter-context")

    treesitter_context.setup(opts)

    vim.keymap.set("n", "gp", function()
      if treesitter_context.enabled() then -- When treesitter-context is not enabled, the keymap doesn't work well
        treesitter_context.go_to_context()
      end
    end, { desc = "Go to context parent node" })
  end,
}
