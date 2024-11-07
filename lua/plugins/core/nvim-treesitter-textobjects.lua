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
        ["ac"] = { query = "@conditional.outer", desc = "a conditional" },
        ["ic"] = { query = "@conditional.inner", desc = "inner conditional" },
        ["af"] = { query = "@call.outer", desc = "a function call" },
        ["if"] = { query = "@call.inner", desc = "inner function call" },
        -- "g" for "comment" reminds the builtin "gc" operator to comment code. It is not a great mnemonic, but it is
        --  very simple to type compared to alternatives (like "#" for Unix or Python comments, or "-" for Lua
        --  comments), so I find it good enough.
        ["ag"] = { query = "@comment.outer", desc = "a comment" },
        ["ig"] = { query = "@comment.inner", desc = "inner comment" },
        ["al"] = { query = "@loop.outer", desc = "a loop" },
        ["il"] = { query = "@loop.inner", desc = "inner loop" },
        ["am"] = { query = "@function.outer", desc = "a method definition" },
        ["im"] = { query = "@function.inner", desc = "inner method definition" },
        -- "o" for "class (OOP)" is not a great mnemonic, but "[" & "]" are already taken for the corresponding bracket
        --  blocks, and I prefer to dedicate "c" to "conditional" as I use it more often. Besides, alternatives like "C"
        --  are harder to type so I prefer to avoid such keys.
        ["ao"] = { query = "@class.outer", desc = "a class (OOP)" },
        ["io"] = { query = "@class.inner", desc = "inner class (OOP)" },
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
      -- Here let's only override some builtin keymaps with the more-powerful Treesitter equivalent
      goto_next_start = {
        ["[["] = { query = "@class.outer", desc = "Next class start" },
        ["[m"] = { query = "@function.outer", desc = "Next method definition start" },
      },
      goto_next_end = {
        ["[]"] = { query = "@class.outer", desc = "Next class end" },
        ["[M"] = { query = "@function.outer", desc = "Next method definition end" },
      },
      goto_previous_start = {
        ["]["] = { query = "@class.outer", desc = "Previous class start" },
        ["]m"] = { query = "@function.outer", desc = "Previous method definition start" },
      },
      goto_previous_end = {
        ["]]"] = { query = "@class.outer", desc = "Previous class end" },
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
        ts_keymap.set_local_move_pair(
          "p",
          function() vim.cmd("normal }") end,
          function() vim.cmd("normal {") end,
          "paragraph"
        )
        ts_keymap.set_local_move_pair( -- Dianostics can be errors, warnings, information messages or hints
          "d",
          vim.diagnostic.goto_next,
          vim.diagnostic.goto_prev,
          "diagnostic"
        )
        ts_keymap.set_local_move_pair(
          "e",
          function() vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR }) end,
          function() vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR }) end,
          "error"
        )
        local url_pattern = "http:\\/\\/\\|https:\\/\\/"
        ts_keymap.set_local_move_pair(
          "w",
          function() vim.fn.search(url_pattern) end,
          function() vim.fn.search(url_pattern, "b") end,
          "Web address"
        )
        -- Conflict markers have 3 forms, all at the start of a line: `<<<<<<< <text>`, ` =======`, ` >>>>>>> <text>`
        local conflict_pattern = "^<<<<<<< \\|^=======\\|^>>>>>>> "
        ts_keymap.set_local_move_pair(
          "x",
          function() vim.fn.search(conflict_pattern) end,
          function() vim.fn.search(conflict_pattern, "b") end,
          "conflict"
        )
        -- Re-implement the builtin bracket navigation keymaps (with "(", "{" & "<") and complete them with the
        --  corresponding closing brackets
        for _, char in ipairs({ "(", ")", "{", "}", "<", ">" }) do
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
        local todo_comment_keywords = { -- Don't include NOTE/INFO, HACK, WARN/WARNING, as they're not actual "todo"
          "FIX",
          "FIXME",
          "BUG",
          "FIXIT",
          "ISSUE",
          "TODO",
          "TODO_",
          "XXX",
          "PERF",
          "OPTIM",
          "PERFORMANCE",
          "OPTIMIZE",
          "TEST",
          "TESTING",
          "PASSED",
          "FAILED",
        }
        ts_keymap.set_local_move_pair(
          "t",
          function() require("todo-comments").jump_next({ keywords = todo_comment_keywords }) end,
          function() require("todo-comments").jump_prev({ keywords = todo_comment_keywords }) end,
          "todo comment"
        )
        ts_keymap.set_local_move_pair(
          "n",
          function() require("todo-comments").jump_next({ keywords = { "TODO_" } }) end,
          function() require("todo-comments").jump_prev({ keywords = { "TODO_" } }) end,
          "todo-now comment"
        )
        ts_keymap.set_local_move_pair(
          "`",
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
        -- Navigate between sentences instead of line siblings with Treesitter (the latter can be replaced by header
        --  navigation)
        ts_keymap.set_local_move_pair(
          "s",
          function() vim.cmd("normal )") end,
          function() vim.cmd("normal (") end,
          "sentence (Markdown)"
        )

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
