-- Which Key
--
-- Which Key is a plugin which helps you remember your Neovim keymaps, by showing available keybindings in a popup as
-- you type, to be able to create keybindings that actually stick. It is, for me, a must to learn and use both builtin
-- and your own keybindings for Neovim.

return {
  "folke/which-key.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  event = "VeryLazy",
  opts = {
    spec = { -- Register keymap groups
      { "gr", group = "LSP" },
      { "<leader> ", group = "Local leader" },
      { "<leader>c", group = "[C]hat", mode = { "n", "v" } },
      { "<leader>d", group = "[D]AP" },
      { "<leader>f", group = "[F]ind", mode = { "n", "v" } },
      { "<leader>g", group = "[G]it", mode = { "n", "v" } },
      { "<leader>n", group = "[N]oice" },
      { "<leader>o", group = "[O]verseer" },
      { "<leader>r", group = "[R]eplace", mode = { "n", "v" } },
      { "<leader>t", group = "[T]erminal" },
      { "<leader>x", group = "Trouble" },
      { "<localleader>f", group = "[F]ind", mode = { "n", "v" } },
      { "<localleader>r", group = "[R]eplace", mode = { "n", "v" } },
    },
    win = { border = "rounded" }, -- Add a border in Which Key UI to improve visibility in transparent backgrounds
    sort = { "order", "alphanum", "mod" }, -- Don't sort local keymaps first and keymap groups last
    icons = { mappings = false }, -- Disable icons as they are not present consistently in my keymaps
  },
}
