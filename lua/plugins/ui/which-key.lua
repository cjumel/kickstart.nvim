-- which-key.nvim
--
-- which-key.nvim helps you remember your Neovim keymaps, by showing available keybindings as you type, to be able to
-- create keybindings that actually stick.

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
      -- Remove "gcc" description for consistency with other "g" keymaps
      if string.sub(mapping.lhs, 1, 3) == "gcc" then
        return false
      end
      -- Remove some weird keymaps (typically introduce by plugins like dial.nvim)
      if string.sub(mapping.lhs, 1, 7) == "g<Plug>" then
        return false
      end
      return true
    end,
    spec = {
      -- Set or modify the description of builtin keymaps
      { "gc", desc = "Comment", mode = { "n", "x" } },
      { "ge", desc = "Previous end of word", mode = { "n", "x", "o" } },
      { "gE", desc = "Previous end of WORD", mode = { "n", "x", "o" } },
      { "gq", desc = "Format (formatexpr)", mode = { "n", "x" } },
      { "gw", desc = "Format", mode = { "n", "x" } },
      -- Register keymap groups
      { "gr", group = "LSP" },
      { "<leader><leader>", group = "Local leader" },
      { "<leader>a", group = "[A]I" },
      { "<leader>d", group = "[D]ebug" },
      { "<leader>f", group = "[F]ind", mode = { "n", "v" } },
      { "<leader>g", group = "[G]it", mode = { "n", "v" } },
      { "<leader>m", group = "Task [M]anager" },
      { "<leader>r", group = "[R]eplace", mode = { "n", "v" } },
      { "<leader>s", group = "[S]cratch" },
      { "<leader>v", group = "[V]iew" },
      { "<leader>x", group = "Test" }, -- Mnemonic: like the failed test symbol
      { "<leader>y", group = "[Y]ank" },
      { "[", group = "Next" },
      { "]", group = "Previous" },
    },
    win = { border = "rounded" }, -- Better for transparent backgrounds
    sort = { "order", "alphanum", "mod" },
    icons = { mappings = false },
  },
}
