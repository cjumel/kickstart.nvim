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
        scope_incremental = "<S-CR>",
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
          ["[a"] = { query = "@parameter.outer", desc = "Next parameter" },
          ["[c"] = { query = "@class.outer", desc = "Next class start" },
          ["[f"] = { query = "@call.outer", desc = "Next function call start" },
          ["[i"] = { query = "@conditional.outer", desc = "Next conditional start" },
          ["[l"] = { query = "@loop.outer", desc = "Next loop start" },
          ["[m"] = { query = "@function.outer", desc = "Next function definition start" },
          ["[="] = { query = "@assignment.outer", desc = "Next assignment" },
          ["[g"] = { query = "@comment.outer", desc = "Next comment" },
        },
        goto_next_end = {
          ["[C"] = { query = "@class.outer", desc = "Next class end" },
          ["[F"] = { query = "@call.outer", desc = "Next function call end" },
          ["[I"] = { query = "@conditional.outer", desc = "Next conditional end" },
          ["[L"] = { query = "@loop.outer", desc = "Next loop end" },
          ["[M"] = { query = "@function.outer", desc = "Next function definition end" },
        },
        goto_previous_start = {
          ["]a"] = { query = "@parameter.outer", desc = "Previous parameter" },
          ["]c"] = { query = "@class.outer", desc = "Previous class start" },
          ["]f"] = { query = "@call.outer", desc = "Previous function call start" },
          ["]i"] = { query = "@conditional.outer", desc = "Previous conditional start" },
          ["]l"] = { query = "@loop.outer", desc = "Previous loop start" },
          ["]m"] = { query = "@function.outer", desc = "Previous function definition start" },
          ["]="] = { query = "@assignment.outer", desc = "Previous assignment" },
          ["]g"] = { query = "@comment.outer", desc = "Previous comment" },
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
    local ts_repeat_move = require("nvim-treesitter.textobjects.repeatable_move")

    local utils = require("utils")

    --- Output wether a Treesitter node is considered as interesting or not. This helps defining
    --- if we want to a particular node or not.
    ---@param node TSNode The node to check.
    ---@return boolean
    local is_insteresting_node = function(node)
      local uninsteresting_node_types = {
        "block", -- Typically the inner part of a function or class
        "comment",
      }
      if utils.table.is_in_array(node:type(), uninsteresting_node_types) then
        return false
      end

      return true
    end

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
        -- Checking a node is interesting solves issues like not being able to navigate siblings
        -- because main node is a block
        and is_insteresting_node(parent)
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
      while parent ~= nil and not is_insteresting_node(parent) do
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
      while sibling ~= nil and not is_insteresting_node(sibling) do
        sibling = sibling:next_named_sibling()
      end

      ts_utils.goto_node(sibling)
    end

    --- Move the cursor to the previous sibling of the current line main node.
    local prev_sibling_node = function()
      local node = get_main_node()
      local sibling = node:prev_named_sibling()

      -- Skip not interesting nodes to avoid jumping to them
      while sibling ~= nil and not is_insteresting_node(sibling) do
        sibling = sibling:prev_named_sibling()
      end

      ts_utils.goto_node(sibling)
    end

    next_sibling_node, prev_sibling_node =
      ts_repeat_move.make_repeatable_move_pair(next_sibling_node, prev_sibling_node)

    vim.keymap.set("n", "gp", go_to_parent_node, { desc = "Go to parent node" })
    vim.keymap.set("n", "[s", next_sibling_node, { desc = "Next sibling node" })
    vim.keymap.set("n", "]s", prev_sibling_node, { desc = "Previous sibling node" })
  end,
}
