return {
  "akinsho/git-conflict.nvim",
  event = { "BufReadPre" },
  opts = {
    default_mappings = false, -- Keymaps are implemented in Hydra.nvim and nvim-treesitter-textobjects
    disable_diagnostics = true,
  },
}
