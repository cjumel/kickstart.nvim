-- which-key.nvim
--
-- which-key.nvim is a plugin which helps you remember your Neovim keymaps, by showing available keybindings in a popup
-- as you type, to be able to create keybindings that actually stick. It is, for me, a must to learn and use builtin and
-- custom keybindings in Neovim.

return {
  "folke/which-key.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  event = "VeryLazy",
  opts = {
    filter = function(mapping)
      -- Filter out builtin next/previous move keymaps, as I implemented them in a very different way
      if string.sub(mapping.lhs, 1, 1) == "[" and (not mapping.desc or string.sub(mapping.desc, 1, 5) ~= "Next ") then
        return false
      end
      if
        string.sub(mapping.lhs, 1, 1) == "]"
        and (not mapping.desc or string.sub(mapping.desc, 1, 9) ~= "Previous ")
      then
        return false
      end
      return true
    end,
    spec = {
      -- Set or modify the description of builtin keymaps
      { "gc", desc = "Comment", mode = { "n", "x" } },
      { "gcc", desc = "Comment line", mode = { "n", "x" } },
      { "ge", desc = "Previous end of word", mode = { "n", "x", "o" } },
      { "gE", desc = "Previous end of WORD", mode = { "n", "x", "o" } },
      { "gq", desc = "Format (formatexpr)", mode = { "n", "x" } },
      { "gw", desc = "Format", mode = { "n", "x" } },
      -- Register keymap groups
      { "gr", group = "LSP" },
      { "<leader> ", group = "Local leader" },
      { "<leader>c", group = "[C]hat", mode = { "n", "v" } },
      { "<leader>f", group = "[F]ind", mode = { "n", "v" } },
      { "<leader>g", group = "[G]it", mode = { "n", "v" } },
      { "<leader>t", group = "[T]emp files" },
      { "<leader>v", group = "[V]iew" },
      { "<leader>x", group = "E[X]ecute" },
      { "<leader>y", group = "[Y]ank" },
      { "<localleader>y", group = "[Y]ank" },
      { "[", group = "Next" },
      { "]", group = "Previous" },
    },
    win = { border = "rounded" }, -- Better for transparent backgrounds
    sort = { "order", "alphanum", "mod" },
    icons = { mappings = false },
  },
}
