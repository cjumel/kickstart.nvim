return {
  "folke/which-key.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  event = "VeryLazy",
  opts = {
    replace = {
      key = {
        function(key)
          -- Improve display of Harpoon keymaps
          if key == "à" then
            return "0"
          end
          if key == "&" then
            return "1~9"
          end
          return require("which-key.view").format(key)
        end,
      },
    },
    filter = function(mapping)
      if string.sub(mapping.lhs, 1, 1) == "[" and (not mapping.desc or string.sub(mapping.desc, 1, 5) ~= "Next ") then
        return false
      end
      if
        string.sub(mapping.lhs, 1, 1) == "]"
        and (not mapping.desc or string.sub(mapping.desc, 1, 9) ~= "Previous ")
      then
        return false
      end
      if mapping.lhs == "gcc" then -- For consistency with other "g" keymaps
        return false
      end
      if mapping.desc == "<which-key-ignore>" then
        return false
      end
      return true
    end,
    spec = {
      -- Set or modify the description of builtin keymaps
      { "gc", desc = "Comment", mode = { "n", "x" } },
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
