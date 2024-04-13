-- nvim-treesitter
--
-- Treesitter configurations and abstraction layer for Neovim.

return {
  "nvim-treesitter/nvim-treesitter",
  dependencies = {
    "nvim-treesitter/nvim-treesitter-context",
    "nvim-treesitter/nvim-treesitter-textobjects",
  },
  build = ":TSUpdate",
  event = { "BufNewFile", "BufReadPre" },
  opts = {
    ensure_installed = { -- Languages treesitter must install
      "bash",
      "csv",
      "diff",
      "dockerfile",
      "git_config",
      "git_rebase",
      "gitattributes",
      "gitcommit",
      "gitignore",
      "json",
      "lua",
      "luadoc", -- lua docstrings
      "luap", -- lua patterns
      "make",
      "markdown",
      "markdown_inline",
      "norg",
      "python",
      "regex",
      "requirements",
      "sql",
      "ssh_config",
      "toml",
      "vim",
      "yaml",
    },
    sync_install = false, -- Install parsers synchronously (only applied to `ensure_installed`)
    auto_install = false, -- Autoinstall languages that are not installed
    ignore_install = {}, -- List of parsers to ignore installing (or "all")
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
    textobjects = {
      select = {
        enable = true,
        lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
        keymaps = { -- You can use the capture groups defined in textobjects.scm
          ["aa"] = { query = "@parameter.outer", desc = "a parameter" },
          ["ia"] = { query = "@parameter.inner", desc = "inner parameter" },
          ["ac"] = { query = "@class.outer", desc = "a class" },
          ["ic"] = { query = "@class.inner", desc = "inner class" },
          ["af"] = { query = "@call.outer", desc = "a function call" },
          ["if"] = { query = "@call.inner", desc = "inner function call" },
          ["ai"] = { query = "@conditional.outer", desc = "a conditional" },
          ["ii"] = { query = "@conditional.inner", desc = "inner conditional" },
          ["al"] = { query = "@loop.outer", desc = "a loop" },
          ["il"] = { query = "@loop.inner", desc = "inner loop" },
          ["am"] = { query = "@function.outer", desc = "a function defintion" },
          ["im"] = { query = "@function.inner", desc = "inner function definition" },
          ["a="] = { query = "@assignment.outer", desc = "an assignment" },
          ["i="] = { query = "@assignment.inner", desc = "inner assignment" },
          ["=h"] = { query = "@assignment.lhs", desc = "assignment left hand side" },
          ["=l"] = { query = "@assignment.rhs", desc = "assignment right hand side" },
          ["ag"] = { query = "@comment.outer", desc = "a comment" },
          ["ig"] = { query = "@comment.inner", desc = "inner comment" },
        },
      },
      move = {
        enable = true,
        set_jumps = true, -- whether to set jumps in the jumplist
        goto_next_start = {
          ["[c"] = { query = "@class.outer", desc = "Next class start" },
          ["[f"] = { query = "@call.outer", desc = "Next function call start" },
          ["[i"] = { query = "@conditional.outer", desc = "Next conditional start" },
          ["[l"] = { query = "@loop.outer", desc = "Next loop start" },
          ["[m"] = { query = "@function.outer", desc = "Next function definition start" },
        },
        goto_next_end = {
          ["[C"] = { query = "@class.outer", desc = "Next class end" },
          ["[F"] = { query = "@call.outer", desc = "Next function call end" },
          ["[I"] = { query = "@conditional.outer", desc = "Next conditional end" },
          ["[L"] = { query = "@loop.outer", desc = "Next loop end" },
          ["[M"] = { query = "@function.outer", desc = "Next function definition end" },
        },
        goto_previous_start = {
          ["]c"] = { query = "@class.outer", desc = "Previous class start" },
          ["]f"] = { query = "@call.outer", desc = "Previous function call start" },
          ["]i"] = { query = "@conditional.outer", desc = "Previous conditional start" },
          ["]l"] = { query = "@loop.outer", desc = "Previous loop start" },
          ["]m"] = { query = "@function.outer", desc = "Previous function definition start" },
        },
        goto_previous_end = {
          ["]C"] = { query = "@class.outer", desc = "Previous class end" },
          ["]F"] = { query = "@call.outer", desc = "Previous function call end" },
          ["]I"] = { query = "@conditional.outer", desc = "Previous conditional end" },
          ["]L"] = { query = "@loop.outer", desc = "Previous loop end" },
          ["]M"] = { query = "@function.outer", desc = "Previous function definition end" },
        },
      },
    },
  },
  config = function(_, opts)
    require("nvim-treesitter.configs").setup(opts)

    local ts_utils = require("nvim-treesitter.ts_utils")

    local utils = require("utils")

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

    --- Move the cursor to the parent of the current line main node.
    local go_to_parent_node = function()
      local node = get_main_node()
      local parent = node:parent()

      -- Skip not interesting nodes to avoid jumping to them
      while
        parent ~= nil
        -- Jumping to a "block" is quite useless; besides, since it's excluded in `get_main_node`,
        -- if we leave it we can't jump to its parent once we're on it
        and parent:type() == "block"
      do
        node = parent
        parent = node:parent()
      end

      ts_utils.goto_node(parent)
    end

    --- Move the cursor to the next sibling of the current line main node.
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
    local prev_sibling_node = function()
      local node = get_main_node()
      local sibling = node:prev_named_sibling()

      -- Skip not interesting nodes to avoid jumping to them
      while sibling ~= nil and sibling:type() == "comment" do
        sibling = sibling:prev_named_sibling()
      end

      ts_utils.goto_node(sibling)
    end

    vim.keymap.set("n", "gp", go_to_parent_node, { desc = "Go to parent node" })
    utils.keymap.set_move_pair({ "[s", "]s" }, {
      next_sibling_node,
      prev_sibling_node,
    }, { { desc = "Next sibling node" }, { desc = "Previous sibling node" } })
  end,
}
