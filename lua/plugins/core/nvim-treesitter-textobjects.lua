-- nvim-treesitter-textobjects
--
-- nvim-treesitter-textobject provides syntax aware text-objects, select, move, swap, and peek support. This plugin
-- completes the nvim-treesitter plugin with the amazing feature of language-aware text-objects operations, another must
-- in my opinion.

return {
  "nvim-treesitter/nvim-treesitter-textobjects",
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  event = "VeryLazy", -- Load at startup as many keymaps in the plugin config
  opts = {
    select = {
      enable = true,
      lookahead = true, -- Automatically jump forward to text-object if not on one
      keymaps = {
        ["aa"] = { query = "@parameter.outer", desc = "an argument" },
        ["ia"] = { query = "@parameter.inner", desc = "inner argument" },
        ["ac"] = { query = "@class.outer", desc = "a class" },
        ["ic"] = { query = "@class.inner", desc = "inner class" },
        ["af"] = { query = "@call.outer", desc = "a function call" },
        ["if"] = { query = "@call.inner", desc = "inner function call" },
        ["ag"] = { query = "@comment.outer", desc = "a comment" },
        ["ig"] = { query = "@comment.inner", desc = "inner comment" },
        ["ai"] = { query = "@conditional.outer", desc = "an if statement" },
        ["ii"] = { query = "@conditional.inner", desc = "inner if statement" },
        ["al"] = { query = "@loop.outer", desc = "a loop" },
        ["il"] = { query = "@loop.inner", desc = "inner loop" },
        ["am"] = { query = "@function.outer", desc = "a method definition" },
        ["im"] = { query = "@function.inner", desc = "inner method definition" },
        ["a="] = { query = "@assignment.outer", desc = "an assignment" },
        ["i="] = { query = "@assignment.inner", desc = "inner assignment" },
        ["gl"] = { query = "@assignment.lhs", desc = "Left-hand-side of assignment" },
        ["gr"] = { query = "@assignment.rhs", desc = "Right-hand-side of assignment" },
      },
    },
    move = {
      enable = true,
      set_jumps = true, -- Set jumps in the jumplist
      goto_next_start = {
        ["[c"] = { query = "@class.outer", desc = "Next class start" },
        ["[m"] = { query = "@function.outer", desc = "Next method definition start" },
      },
      goto_next_end = {
        ["[C"] = { query = "@class.outer", desc = "Next class end" },
        ["[M"] = { query = "@function.outer", desc = "Next method definition end" },
      },
      goto_previous_start = {
        ["]c"] = { query = "@class.outer", desc = "Previous class start" },
        ["]m"] = { query = "@function.outer", desc = "Previous method definition start" },
      },
      goto_previous_end = {
        ["]C"] = { query = "@class.outer", desc = "Previous class end" },
        ["]M"] = { query = "@function.outer", desc = "Previous method definition end" },
      },
    },
    swap = {
      enable = true,
      swap_next = {
        ["ga"] = { query = "@parameter.inner", desc = "Swap argument with next" },
      },
      swap_previous = {
        ["gA"] = { query = "@parameter.inner", desc = "Swap argument with previous" },
      },
    },
  },
  config = function(_, opts)
    require("nvim-treesitter.configs").setup({ textobjects = opts })

    local repeatable_move = require("nvim-treesitter.textobjects.repeatable_move")
    vim.keymap.set(
      { "n", "x", "o" },
      ",",
      repeatable_move.repeat_last_move_next,
      { desc = 'Repeat last move in "next" direction' }
    )
    vim.keymap.set(
      { "n", "x", "o" },
      ";",
      repeatable_move.repeat_last_move_previous,
      { desc = 'Repeat last move in "previous" direction' }
    )
  end,
}
