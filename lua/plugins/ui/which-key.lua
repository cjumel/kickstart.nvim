return {
  "folke/which-key.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  event = "VeryLazy",
  opts = {
    spec = {
      -- Set or modify the description of builtin keymaps
      { "gq", desc = "Format (formatexpr)", mode = { "n", "x" } },
      -- Register keymap groups
      { "gr", group = "LSP" },
      { "<leader><leader>", group = "Local leader" },
      { "<leader>d", group = "[D]ebug" },
      { "<leader>e", group = "[E]xecute" },
      { "<leader>f", group = "[F]ind", mode = { "n", "v" } },
      { "<leader>g", group = "[G]it", mode = { "n", "v" } },
      { "<leader>s", group = "[S]cratch" },
      { "<leader>t", group = "[T]est" },
      { "<leader>v", group = "[V]iew" },
      { "<leader>x", group = "Delete" },
      { "<leader>y", group = "[Y]ank" },
    },
    win = { border = "rounded" }, -- Better for transparent backgrounds
    sort = { "order", "alphanum", "mod" },
    icons = { mappings = false },
  },
}
