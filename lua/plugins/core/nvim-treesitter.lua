-- nvim-treesitter
--
-- Treesitter configurations and abstraction layer for Neovim. This plugin integrates Treesitter in Neovim, providing
-- various language-specific features (highlighting, indentation, incremental selection, etc.) It is a must-have for
-- any Neovim user, in my opinion.

return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  event = "VeryLazy", -- Force load on start-up to ensure all parsers are always installed
  opts = {
    ensure_installed = {
      "bash",
      "csv",
      "diff",
      "dockerfile",
      "editorconfig",
      "git_config",
      "git_rebase",
      "gitattributes",
      "gitcommit",
      "gitignore",
      "json",
      "jsonc",
      "lua",
      "luadoc", -- Lua docstrings
      "luap", -- Lua search patterns
      "make",
      "markdown",
      "markdown_inline", -- For advanced Markdown stuff, like concealing
      "python",
      "regex",
      "requirements",
      "sql",
      "ssh_config",
      "tmux",
      "toml",
      "typst",
      "vim",
      "vimdoc", -- For Vim help files
      "yaml",
    },
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
    -- There are also go to next/previous sibling keymaps, but they are defined in nvim-treesitter-textobjects due
    --  to the way the dependencies between the plugins are defined
    local ts_actions = require("plugins.core.nvim-treesitter.actions")
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "*",
      callback = function()
        -- Don't set keymaps if no Treesitter parser is installed for the buffer
        if not require("nvim-treesitter.parsers").has_parser() then
          return
        end

        vim.keymap.set("n", "gp", ts_actions.go_to_parent_node, { desc = "Go to line parent node", buffer = true })
      end,
      group = vim.api.nvim_create_augroup("NvimTreesitterKeymaps", { clear = true }),
    })
  end,
}
