-- Zen-mode
--
-- Zen mode, striped out of distractions, for Neovim.

-- ISSUE:
-- When in zen-mode, switching file sometimes messes with the zen-mode options, see
-- https://github.com/folke/zen-mode.nvim/issues/95

return {
  "folke/zen-mode.nvim",
  keys = {
    {
      "<leader>z",
      function()
        -- Zen-mode doesn't disable the status line if `vim.o.laststatus = 3`, let's fix this
        -- (this shouldn't be used for other values of `vim.o.laststatus`)
        if require("zen-mode.view").is_open() then
          vim.o.laststatus = 3
        else
          vim.o.laststatus = 0
        end

        require("zen-mode").toggle()
      end,
      desc = "[Z]en mode",
      ft = "*",
    },
  },
  opts = {
    window = {
      backdrop = 1, -- No difference between the background and the window
      width = 106, -- Give some room for line numbers and column signs
      options = {
        number = false, -- Disable number column
        relativenumber = false,
        colorcolumn = "0", -- Disable column ruler
      },
    },
    plugins = {
      twilight = { enabled = false }, -- Don't enable Twilight when entering zen mode
      tmux = { enabled = true }, -- Disable Tmux status line when entering zen mode
    },
  },
}
