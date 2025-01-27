-- nvim-treesitter
--
-- Treesitter configurations and abstraction layer for Neovim. This plugin integrates Treesitter in Neovim, providing
-- various language-specific features (highlighting, indentation, incremental selection, etc.) It is a must-have for
-- any Neovim user, in my opinion.

return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  event = { "BufNewFile", "BufReadPre" },
  cmd = { "TSInstallInfo" }, -- To trigger the parsers automatic install directly from a command
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
  config = function(_, opts)
    require("nvim-treesitter.configs").setup(opts)

    -- Create buffer-specific keymaps
    local ts_actions = require("plugins.core.nvim-treesitter.actions")
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "*",
      callback = function()
        if not require("nvim-treesitter.parsers").has_parser() then -- No parser is installed for the buffer
          return
        end
        vim.keymap.set("n", "gp", ts_actions.go_to_parent_node, { desc = "Go to line parent node", buffer = true })
      end,
      group = vim.api.nvim_create_augroup("NvimTreesitterKeymaps", { clear = true }),
    })
  end,
}
