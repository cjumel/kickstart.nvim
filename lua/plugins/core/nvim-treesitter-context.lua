return {
  "nvim-treesitter/nvim-treesitter-context",
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  keys = { { "<leader>vc", function() require("treesitter-context").toggle() end, desc = "[V]iew: [C]ontext" } },
  opts = {
    enable = false,
  },
}
