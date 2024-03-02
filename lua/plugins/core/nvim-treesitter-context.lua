-- nvim-treesitter-context
--
-- Use treesitter to show the context of the currently visible buffer contents.

return {
  "nvim-treesitter/nvim-treesitter-context",
  lazy = true,
  opts = {
    enable = false, -- Keep the plugin disabled by default and only enable it via keymaps
    separator = "-", -- Add a dash-line between the context and the buffer contents
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
    vim.keymap.set(
      "n",
      "gP", -- gp is used to go to treesitter parent node
      function()
        if not treesitter_context.enabled() then
          return
        end

        treesitter_context.go_to_context(vim.v.count1)
        vim.cmd("normal! zz") -- make sure remaining context can be displayed
      end,
      { desc = "Go to context parent node", silent = true }
    )
  end,
}
