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

    local keymap = require("keymap")
    local ts_utils = require("nvim-treesitter.ts_utils")

    --- Output the current line main node, that is the top-level ancestor from the node under the
    --- cursor within the same line.
    ---@return TSNode
    local get_main_node = function()
      local node = ts_utils.get_node_at_cursor()
      if node == nil then
        error("No Treesitter parser found.")
      end
      local start_row = node:start()
      local parent = node:parent()
      while
        parent ~= nil
        and parent:start() == start_row
        -- A "block" is typically the inner part of a function or class
        -- Excluding it makes possible to navigate to a sibling within a block from the first line
        and parent:type() ~= "block"
      do
        node = parent
        parent = node:parent()
      end
      return node
    end

    --- Move the cursor to the next sibling of the current line main node.
    ---@return nil
    local next_sibling_node = function()
      local node = get_main_node()
      local sibling = node:next_named_sibling()
      -- Skip not interesting nodes to avoid jumping to them
      while sibling ~= nil and sibling:type() == "comment" do
        sibling = sibling:next_named_sibling()
      end
      ts_utils.goto_node(sibling)
    end

    --- Move the cursor to the previous sibling of the current line main node.
    ---@return nil
    local prev_sibling_node = function()
      local node = get_main_node()
      local sibling = node:prev_named_sibling()
      -- Skip not interesting nodes to avoid jumping to them
      while sibling ~= nil and sibling:type() == "comment" do
        sibling = sibling:prev_named_sibling()
      end
      ts_utils.goto_node(sibling)
    end

    keymap.set_move_pair(
      { "[s", "]s" },
      { next_sibling_node, prev_sibling_node },
      { { desc = "Next line sibling" }, { desc = "Previous line sibling" } }
    )
  end,
}
