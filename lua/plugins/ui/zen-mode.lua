-- Zen-mode
--
-- Zen mode, striped out of distractions, for Neovim.

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
    },
  },
  opts = {
    window = {
      backdrop = 1, -- No difference between the background and the window
      width = 100,
      options = {
        number = false, -- Disable number column
        relativenumber = false,
      },
    },
    plugins = {
      tmux = { enabled = true }, -- Disable Tmux status line
    },
  },
}
