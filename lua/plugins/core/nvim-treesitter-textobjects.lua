-- nvim-treesitter-textobjects
--
-- nvim-treesitter-textobject provides syntax aware text-objects, select, move, swap, and peek support. This plugin
-- completes the nvim-treesitter plugin with the amazing feature of language-aware text-objects operations, another must
-- in my opinion.

return {
  "nvim-treesitter/nvim-treesitter-textobjects",
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  event = {
    "VeryLazy", -- Necessary to set not buffer-specific keymaps
    "BufReadPre", -- In case Neovim directly opens a buffer, "VeryLazy" is too late to set keymaps
  },
  opts = {
    select = {
      enable = true,
      lookahead = true, -- Automatically jump forward to text-object if not on one
      keymaps = {
        ["aa"] = { query = "@parameter.outer", desc = "an argument" },
        ["ia"] = { query = "@parameter.inner", desc = "inner argument" },
        ["ac"] = { query = "@class.outer", desc = "a class" },
        ["ic"] = { query = "@class.inner", desc = "inner class" },
        ["ad"] = { query = "@function.outer", desc = "a function definition" },
        ["id"] = { query = "@function.inner", desc = "inner function definition" },
        ["af"] = { query = "@call.outer", desc = "a function call" },
        ["if"] = { query = "@call.inner", desc = "inner function call" },
        ["ag"] = { query = "@comment.outer", desc = "a comment" }, -- "g" like builtin "gc" operator
        ["ig"] = { query = "@comment.inner", desc = "inner comment" }, -- "g" like builtin "gc" operator
        ["ai"] = { query = "@conditional.outer", desc = "an if/else if/else statement" },
        ["ii"] = { query = "@conditional.inner", desc = "inner if/else if/else statement" },
        ["al"] = { query = "@loop.outer", desc = "a loop" },
        ["il"] = { query = "@loop.inner", desc = "inner loop" },
        ["ar"] = { query = "@return.outer", desc = "a return statement" },
        ["ir"] = { query = "@return.inner", desc = "inner return statement" },
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
        ["[d"] = { query = "@function.outer", desc = "Next function definition start" },
      },
      goto_next_end = {
        ["[C"] = { query = "@class.outer", desc = "Next class end" },
        ["[D"] = { query = "@function.outer", desc = "Next function definition end" },
      },
      goto_previous_start = {
        ["]c"] = { query = "@class.outer", desc = "Previous class start" },
        ["]d"] = { query = "@function.outer", desc = "Previous function definition start" },
      },
      goto_previous_end = {
        ["]C"] = { query = "@class.outer", desc = "Previous class end" },
        ["]D"] = { query = "@function.outer", desc = "Previous function definition end" },
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

    local tdc_actions = require("plugins.core.todo-comments.actions")
    local ts_actions = require("plugins.core.nvim-treesitter.actions")
    local ts_keymap = require("plugins.core.nvim-treesitter-textobjects.keymap")
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

    -- Create generic keymaps
    ts_keymap.set_move_pair("b", function() vim.cmd("bnext") end, function() vim.cmd("bprev") end, "buffer")
    ts_keymap.set_move_pair(
      "l",
      function() vim.cmd("silent! lnext") end,
      function() vim.cmd("silent! lprev") end,
      "loclist item"
    )
    ts_keymap.set_move_pair(
      "q",
      function() vim.cmd("silent! cnext") end,
      function() vim.cmd("silent! cprev") end,
      "qflist item"
    )

    -- Create buffer-specific keymaps
    local augroup = vim.api.nvim_create_augroup("NvimTreesitterTextobjectsKeymaps", { clear = true })

    vim.api.nvim_create_autocmd("FileType", {
      pattern = "*",
      group = augroup,
      callback = function()
        ts_keymap.set_local_move_pair( -- Dianostics can be errors, warnings, information messages or hints
          "$", -- Like <C-$> to open diagnostic
          vim.diagnostic.goto_next,
          vim.diagnostic.goto_prev,
          "diagnostic"
        )
        local url_pattern = "http:\\/\\/\\|https:\\/\\/"
        ts_keymap.set_local_move_pair(
          "a", -- Like "ga" text-object for web addresses
          function() vim.fn.search(url_pattern) end,
          function() vim.fn.search(url_pattern, "b") end,
          "Web address"
        )
        -- Conflict markers have 3 forms, all at the start of a line: `<<<<<<< <text>`, ` =======`, ` >>>>>>> <text>`
        local conflict_pattern = "^<<<<<<< \\|^=======\\|^>>>>>>> "
        ts_keymap.set_local_move_pair(
          "=",
          function() vim.fn.search(conflict_pattern) end,
          function() vim.fn.search(conflict_pattern, "b") end,
          "conflict"
        )
        -- Re-implement the builtin bracket navigation keymaps (with "(", "{" & "<") and complete them with the
        -- corresponding closing brackets and the square bracket equivalents
        for _, char in ipairs({ "(", ")", "{", "}", "<", ">", "[", "]" }) do
          ts_keymap.set_local_move_pair(
            char,
            function() vim.fn.search(char) end,
            function() vim.fn.search(char, "b") end,
            char
          )
        end
        ts_keymap.set_local_move_pair(
          "h",
          function() require("gitsigns").next_hunk({ navigation_message = false }) end,
          function() require("gitsigns").prev_hunk({ navigation_message = false }) end,
          "hunk"
        )
        ts_keymap.set_local_move_pair(
          "p",
          tdc_actions.next_personal_todo,
          tdc_actions.prev_personal_todo,
          "personal todo-comment"
        )
        ts_keymap.set_local_move_pair("t", tdc_actions.next_todo, tdc_actions.prev_todo, "todo todo-comment")
        ts_keymap.set_local_move_pair("n", tdc_actions.next_note, tdc_actions.prev_note, "note todo-comment")
        ts_keymap.set_local_move_pair(
          "m",
          function() require("marks").next() end,
          function() require("marks").prev() end,
          "mark"
        )

        -- Don't set the remaining keymaps if no Treesitter parser is installed for the buffer
        if not require("nvim-treesitter.parsers").has_parser() then
          return
        end

        ts_keymap.set_local_move_pair("s", ts_actions.next_sibling_node, ts_actions.prev_sibling_node, "line sibling")
      end,
    })

    vim.api.nvim_create_autocmd("FileType", {
      pattern = "markdown",
      group = augroup,
      callback = function()
        -- Navigate between GitHub-flavored Markdown todo checkboxes (not started or in progress), instead of
        --  todo-comments (which are not supported in Markdown by todo-comments.nvim anyway)
        local todo_checkbox_pattern = "- \\[ ] \\|- \\[-] "
        ts_keymap.set_local_move_pair(
          "t",
          function() vim.fn.search(todo_checkbox_pattern) end,
          function() vim.fn.search(todo_checkbox_pattern, "b") end,
          "todo checkbox (Markdown)"
        )
      end,
    })
  end,
}
