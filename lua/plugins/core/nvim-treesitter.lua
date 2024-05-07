-- nvim-treesitter
--
-- Treesitter configurations and abstraction layer for Neovim.

return {
  "nvim-treesitter/nvim-treesitter",
  dependencies = { "nvim-treesitter/nvim-treesitter-textobjects" },
  build = ":TSUpdate",
  event = { "BufNewFile", "BufReadPre" },
  opts = {
    ensure_installed = {
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
      "luadoc", -- Lua docstrings
      "luap", -- Lua search patterns
      "make",
      "markdown", -- Regular Markdown
      "markdown_inline", -- For advanced Markdown stuff, like concealing
      "python",
      "regex",
      "requirements",
      "sql",
      "ssh_config",
      "tmux",
      "toml",
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
    textobjects = {
      select = {
        enable = true,
        lookahead = true, -- Automatically jump forward to text-object if not on one
        keymaps = {
          ["a["] = { query = "@class.outer", desc = "a class" },
          ["i["] = { query = "@class.inner", desc = "inner class" },
          ["aa"] = { query = "@parameter.outer", desc = "an argument" },
          ["ia"] = { query = "@parameter.inner", desc = "inner argument" },
          ["ac"] = { query = "@conditional.outer", desc = "a conditional" },
          ["ic"] = { query = "@conditional.inner", desc = "inner conditional" },
          ["af"] = { query = "@call.outer", desc = "a function call" },
          ["if"] = { query = "@call.inner", desc = "inner function call" },
          ["ag"] = { query = "@comment.outer", desc = "a comment" },
          ["ig"] = { query = "@comment.inner", desc = "inner comment" },
          ["al"] = { query = "@loop.outer", desc = "a loop" },
          ["il"] = { query = "@loop.inner", desc = "inner loop" },
          ["am"] = { query = "@function.outer", desc = "a method defintion" },
          ["im"] = { query = "@function.inner", desc = "inner method definition" },
          ["gaa"] = { query = "@assignment.outer", desc = "an assignment" },
          ["gai"] = { query = "@assignment.inner", desc = "inner assignment" },
          ["gal"] = { query = "@assignment.lhs", desc = "assignment left hand side" },
          ["gar"] = { query = "@assignment.rhs", desc = "assignment right hand side" },
        },
      },
      move = {
        enable = true,
        set_jumps = true, -- Set jumps in the jumplist
        goto_next_start = {
          ["[["] = { query = "@class.outer", desc = "Next class start" },
          ["[a"] = { query = "@parameter.outer", desc = "Next argument start" },
          ["[c"] = { query = "@conditional.outer", desc = "Next conditional start" },
          ["[f"] = { query = "@call.outer", desc = "Next function call start" },
          ["[l"] = { query = "@loop.outer", desc = "Next loop start" },
          ["[m"] = { query = "@function.outer", desc = "Next method definition start" },
        },
        goto_next_end = {
          ["[]"] = { query = "@class.outer", desc = "Next class end" },
          ["[A"] = { query = "@parameter.outer", desc = "Next argument end" },
          ["[C"] = { query = "@conditional.outer", desc = "Next conditional end" },
          ["[F"] = { query = "@call.outer", desc = "Next function call end" },
          ["[L"] = { query = "@loop.outer", desc = "Next loop end" },
          ["[M"] = { query = "@function.outer", desc = "Next method definition end" },
        },
        goto_previous_start = {
          ["]["] = { query = "@class.outer", desc = "Previous class start" },
          ["]a"] = { query = "@parameter.outer", desc = "Previous argument start" },
          ["]c"] = { query = "@conditional.outer", desc = "Previous conditional start" },
          ["]f"] = { query = "@call.outer", desc = "Previous function call start" },
          ["]l"] = { query = "@loop.outer", desc = "Previous loop start" },
          ["]m"] = { query = "@function.outer", desc = "Previous method definition start" },
        },
        goto_previous_end = {
          ["]]"] = { query = "@class.outer", desc = "Previous class end" },
          ["]A"] = { query = "@parameter.outer", desc = "Previous argument end" },
          ["]C"] = { query = "@conditional.outer", desc = "Previous conditional end" },
          ["]F"] = { query = "@call.outer", desc = "Previous function call end" },
          ["]L"] = { query = "@loop.outer", desc = "Previous loop end" },
          ["]M"] = { query = "@function.outer", desc = "Previous method definition end" },
        },
      },
      swap = {
        enable = true,
        swap_next = {
          ["<leader>n"] = { query = "@parameter.inner", desc = "[N]ext argument swap" },
        },
        swap_previous = {
          ["<leader>p"] = { query = "@parameter.inner", desc = "[P]revious argument swap" },
        },
      },
    },
  },
  config = function(_, opts)
    local ts_config = require("nvim-treesitter.configs")
    local ts_utils = require("nvim-treesitter.ts_utils")

    local utils = require("utils")

    ts_config.setup(opts)

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

    utils.keymap.set_move_pair({ "[s", "]s" }, {
      next_sibling_node,
      prev_sibling_node,
    }, { { desc = "Next sibling node" }, { desc = "Previous sibling node" } })
  end,
}
