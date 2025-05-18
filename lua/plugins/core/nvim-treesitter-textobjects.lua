-- nvim-treesitter-textobjects
--
-- nvim-treesitter-textobject provides syntax aware text-objects, select, move, swap, and peek support. This plugin
-- completes the nvim-treesitter plugin with the amazing feature of language-aware text-objects operations, another must
-- in my opinion.

return {
  "nvim-treesitter/nvim-treesitter-textobjects",
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  event = { "BufNewFile", "BufReadPre" },
  keys = { -- We only need to specify the non buffer-specific keymaps
    { "[l", desc = "Next loclist item" },
    { "]l", desc = "Previous loclist item" },
    { "[q", desc = "Next qflist item" },
    { "]q", desc = "Previous qflist item" },
  },
  opts = {
    select = {
      enable = true,
      lookahead = true, -- Automatically jump forward to text-object if not on one
      keymaps = {
        ["aa"] = { query = "@parameter.outer", desc = "argument" },
        ["ia"] = { query = "@parameter.inner", desc = "inner argument" },
        ["ac"] = { query = "@class.outer", desc = "class definition" },
        ["ic"] = { query = "@class.inner", desc = "inner class definition" },
        ["af"] = { query = "@call.outer", desc = "function call" },
        ["if"] = { query = "@call.inner", desc = "inner function call" },
        ["ag"] = { query = "@comment.outer", desc = "comment" }, -- "g" like builtin "gc" operator
        ["ig"] = { query = "@comment.inner", desc = "inner comment" }, -- "g" like builtin "gc" operator
        ["ai"] = { query = "@conditional.outer", desc = "if/else if/else statement" },
        ["ii"] = { query = "@conditional.inner", desc = "inner if/else if/else statement" },
        ["al"] = { query = "@loop.outer", desc = "loop" },
        ["il"] = { query = "@loop.inner", desc = "inner loop" },
        ["am"] = { query = "@function.outer", desc = "method definition" },
        ["im"] = { query = "@function.inner", desc = "inner method definition" },
        ["ar"] = { query = "@return.outer", desc = "return statement" },
        ["ir"] = { query = "@return.inner", desc = "inner return statement" },
        ["a="] = { query = "@assignment.outer", desc = "assignment" },
        ["i="] = { query = "@assignment.inner", desc = "inner assignment" },
        ["gl"] = { query = "@assignment.lhs", desc = "Left-hand-side of assignment" },
        ["gr"] = { query = "@assignment.rhs", desc = "Right-hand-side of assignment" },
      },
    },
    move = {
      enable = true,
      set_jumps = true, -- Set jumps in the jumplist
      goto_next_start = {
        ["[c"] = { query = "@class.outer", desc = "Next class definition start" },
        ["[g"] = { query = "@comment.outer", desc = "Next comment" },
        ["[m"] = { query = "@function.outer", desc = "Next function definition start" },
      },
      goto_next_end = {
        ["[C"] = { query = "@class.outer", desc = "Next class definition end" },
        ["[M"] = { query = "@function.outer", desc = "Next function definition end" },
      },
      goto_previous_start = {
        ["]c"] = { query = "@class.outer", desc = "Previous class definition start" },
        ["]g"] = { query = "@comment.outer", desc = "Previous comment" },
        ["]m"] = { query = "@function.outer", desc = "Previous function definition start" },
      },
      goto_previous_end = {
        ["]C"] = { query = "@class.outer", desc = "Previous class definition end" },
        ["]M"] = { query = "@function.outer", desc = "Previous function definition end" },
      },
    },
  },
  config = function(_, opts)
    require("nvim-treesitter.configs").setup({ textobjects = opts })

    local ts_repeatable_move = require("nvim-treesitter.textobjects.repeatable_move")

    -- Define keymaps to repeat last moves
    vim.keymap.set(
      { "n", "x", "o" },
      ",",
      ts_repeatable_move.repeat_last_move_next,
      { desc = 'Repeat last move in "next" direction' }
    )
    vim.keymap.set(
      { "n", "x", "o" },
      ";",
      ts_repeatable_move.repeat_last_move_previous,
      { desc = 'Repeat last move in "previous" direction' }
    )

    ---@param key string The keymap key, to use in addition to "[" or "]" to define the keymaps lhs.
    ---@param forward_move_fn function The function to move in the forward direction to define one of the keymaps rhs.
    ---@param backward_move_fn function The function to move in the backward direction to define the other keymap rhs.
    ---@param name string The keymap name, to use in addition to "Next " or "Previous " to define keymap descriptions.
    ---@return nil
    local function map(key, forward_move_fn, backward_move_fn, name)
      forward_move_fn, backward_move_fn =
        ts_repeatable_move.make_repeatable_move_pair(forward_move_fn, backward_move_fn)
      vim.keymap.set({ "n", "x", "o" }, "[" .. key, forward_move_fn, { desc = "Next " .. name })
      vim.keymap.set({ "n", "x", "o" }, "]" .. key, backward_move_fn, { desc = "Previous " .. name })
    end

    -- Generic keymaps
    map("l", function() vim.cmd("silent! lnext") end, function() vim.cmd("silent! lprev") end, "loclist item")
    map("q", function() vim.cmd("silent! cnext") end, function() vim.cmd("silent! cprev") end, "qflist item")

    -- Buffer-specific keymaps
    local augroup = vim.api.nvim_create_augroup("NvimTreesitterTextobjectsKeymaps", { clear = true })

    ---@param key string The keymap key, to use in addition to "[" or "]" to define the keymaps lhs.
    ---@param next_fn function The function to move in the forward direction to define one of the keymaps rhs.
    ---@param prev_fn function The function to move in the backward direction to define the other keymap rhs.
    ---@param name string The keymap name, to use in addition to "Next " or "Previous " to define keymap descriptions.
    ---@param other_key string The keymap key to use in addition to "]" to define the keymap lhs, if different of `key`.
    ---@return nil
    function map(key, next_fn, prev_fn, name, other_key)
      other_key = other_key or key
      local mode = { "n", "x", "o" }
      next_fn, prev_fn = ts_repeatable_move.make_repeatable_move_pair(next_fn, prev_fn)
      vim.keymap.set(mode, "[" .. key, next_fn, { desc = "Next " .. name, buffer = true })
      vim.keymap.set(mode, "]" .. other_key, prev_fn, { desc = "Previous " .. name, buffer = true })
    end

    vim.api.nvim_create_autocmd("FileType", {
      pattern = "*",
      group = augroup,
      callback = function()
        map(
          "[",
          function() Snacks.words.jump(vim.v.count1, true) end,
          function() Snacks.words.jump(-vim.v.count1, true) end,
          "reference",
          "]"
        )
        map("d", vim.diagnostic.goto_next, vim.diagnostic.goto_prev, "diagnostic")
        map(
          "e",
          function() vim.diagnostic.goto_next({ severity = "ERROR" }) end,
          function() vim.diagnostic.goto_prev({ severity = "ERROR" }) end,
          "error"
        )
        map("`", function() require("marks").next() end, function() require("marks").prev() end, "marks")
        map(
          "h",
          function() require("gitsigns").nav_hunk("next", { target = "all" }) end,
          function() require("gitsigns").nav_hunk("prev", { target = "all" }) end,
          "hunk"
        )
        map(
          "t",
          function() require("todo-comments").jump_next({ keywords = { "NOW" } }) end,
          function() require("todo-comments").jump_prev({ keywords = { "NOW" } }) end,
          "todo-comment (personal)"
        )
        map(
          "T",
          function() require("todo-comments").jump_next() end,
          function() require("todo-comments").jump_prev() end,
          "todo-comment (all)"
        )
        map(
          "x",
          function() require("git-conflict").find_next("ours") end,
          function() require("git-conflict").find_prev("ours") end,
          "conflict"
        )
      end,
    })

    vim.api.nvim_create_autocmd("FileType", {
      pattern = "markdown",
      group = augroup,
      callback = function()
        -- Navigate between GitHub-flavored Markdown todo checkboxes (not started or in progress), instead of
        --  todo-comments (which are not supported in Markdown by todo-comments.nvim anyway)
        local todo_checkbox_pattern = "- \\[ ] \\|- \\[-] "
        map(
          "t",
          function() vim.fn.search(todo_checkbox_pattern) end,
          function() vim.fn.search(todo_checkbox_pattern, "b") end,
          "todo checkbox (Markdown)"
        )
      end,
    })
  end,
}
