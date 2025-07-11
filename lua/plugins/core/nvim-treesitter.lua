-- nvim-treesitter
--
-- Treesitter configurations and abstraction layer for Neovim.

return {
  "nvim-treesitter/nvim-treesitter",
  -- TODO: the `master` branch will not remain the default branch in the future
  branch = "master",
  build = ":TSUpdate",
  lazy = false, -- Lazy-loading is not supported for this plugin
  opts = {
    ensure_installed = Metaconfig.treesitter_ensure_installed,
    highlight = { enable = true },
    indent = { enable = true },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = "<CR>",
        node_incremental = "<CR>",
        scope_incremental = false,
        node_decremental = "<BS>",
      },
    },
  },
  config = function(_, opts) require("nvim-treesitter.configs").setup(opts) end,
}
