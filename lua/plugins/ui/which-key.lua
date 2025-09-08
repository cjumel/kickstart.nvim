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
      { "<leader>b", group = "[B]uffer" },
      { "<leader>d", group = "[D]ebug" },
      { "<leader>e", group = "[E]xecute" },
      { "<leader>f", group = "[F]ind", mode = { "n", "v" } },
      { "<leader>g", group = "[G]it", mode = { "n", "v" } },
      { "<leader>j", group = "[J]ump", mode = { "n", "x", "o" } },
      { "<leader>s", group = "[S]cratch" },
      { "<leader>t", group = "[T]est" },
      { "<leader>v", group = "[V]iew" },
      { "<leader>y", group = "[Y]ank" },
    },
    win = { border = "rounded" }, -- Better for transparent backgrounds
    sort = { "order", "alphanum", "mod" },
    icons = { mappings = false },
  },
}
