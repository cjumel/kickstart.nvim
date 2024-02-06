-- Nvim-treesitter
--
-- Neovim implementation of treesitter, implementing several features (code highlighting,
-- navigation or edition), based on a language parser. Parsers exist for many languages.

return {
  "nvim-treesitter/nvim-treesitter",
  dependencies = {
    "nvim-treesitter/nvim-treesitter-textobjects",
  },
  build = ":TSUpdate",
  config = function()
    require("nvim-treesitter.configs").setup({
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
        "markdown",
        "markdown_inline",
        "python",
        "regex",
        "requirements",
        "sql",
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
          init_selection = "<leader>i",
          node_incremental = "<leader>i",
          scope_incremental = false,
          node_decremental = "<bs>",
        },
      },
      textobjects = {
        select = {
          enable = true,
          lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
          keymaps = { -- You can use the capture groups defined in textobjects.scm
            -- Parameter
            ["aa"] = { query = "@parameter.outer", desc = "a parameter" },
            ["ia"] = { query = "@parameter.inner", desc = "inner parameter" },

            -- Class
            ["ac"] = { query = "@class.outer", desc = "a class" },
            ["ic"] = { query = "@class.inner", desc = "inner class" },

            -- Function call
            ["af"] = { query = "@call.outer", desc = "a function call" },
            ["if"] = { query = "@call.inner", desc = "inner function call" },

            -- Conditional
            ["ai"] = { query = "@conditional.outer", desc = "a conditional" },
            ["ii"] = { query = "@conditional.inner", desc = "inner conditional" },

            -- Loop
            ["al"] = { query = "@loop.outer", desc = "a loop" },
            ["il"] = { query = "@loop.inner", desc = "inner loop" },

            -- Function definition
            ["am"] = { query = "@function.outer", desc = "a function defintion" },
            ["im"] = { query = "@function.inner", desc = "inner function definition" },

            -- Assignment
            ["a="] = { query = "@assignment.outer", desc = "an assignment" },
            ["i="] = { query = "@assignment.inner", desc = "inner assignment" },
            ["=l"] = { query = "@assignment.lhs", desc = "assignment left hand side" },
            ["=r"] = { query = "@assignment.rhs", desc = "assignment right hand side" },

            -- Comment
            ["a#"] = { query = "@comment.outer", desc = "a comment" },
            ["i#"] = { query = "@comment.inner", desc = "inner comment" },
          },
        },
        move = {
          enable = true,
          set_jumps = true, -- whether to set jumps in the jumplist
          goto_next_start = {
            -- Parameter
            ["[a"] = { query = "@parameter.outer", desc = "Next parameter" },

            -- Class
            ["[c"] = { query = "@class.outer", desc = "Next class start" },

            -- Function call
            ["[f"] = { query = "@call.outer", desc = "Next function call start" },

            -- Conditional
            ["[i"] = { query = "@conditional.outer", desc = "Next conditional start" },

            -- Loop
            ["[l"] = { query = "@loop.outer", desc = "Next loop start" },

            -- Function definition
            ["[m"] = { query = "@function.outer", desc = "Next function definition start" },

            -- Assignment
            ["[="] = { query = "@assignment.outer", desc = "Next assignment" },

            -- Comment
            ["[#"] = { query = "@comment.outer", desc = "Next comment" },
          },
          goto_next_end = {
            -- Class
            ["[C"] = { query = "@class.outer", desc = "Next class end" },

            -- Function call
            ["[F"] = { query = "@call.outer", desc = "Next function call end" },

            -- Conditional
            ["[I"] = { query = "@conditional.outer", desc = "Next conditional end" },

            -- Loop
            ["[L"] = { query = "@loop.outer", desc = "Next loop end" },

            -- Function definition
            ["[M"] = { query = "@function.outer", desc = "Next function definition end" },
          },
          goto_previous_start = {
            -- Parameter
            ["]a"] = { query = "@parameter.outer", desc = "Previous parameter" },

            -- Class
            ["]c"] = { query = "@class.outer", desc = "Previous class start" },

            -- Function call
            ["]f"] = { query = "@call.outer", desc = "Previous function call start" },

            -- Conditional
            ["]i"] = { query = "@conditional.outer", desc = "Previous conditional start" },

            -- Loop
            ["]l"] = { query = "@loop.outer", desc = "Previous loop start" },

            -- Function definition
            ["]m"] = { query = "@function.outer", desc = "Previous function definition start" },

            -- Assignment
            ["]="] = { query = "@assignment.outer", desc = "Previous assignment" },

            -- Comment
            ["]#"] = { query = "@comment.outer", desc = "Previous comment" },
          },
          goto_previous_end = {
            -- Class
            ["]C"] = { query = "@class.outer", desc = "Previous class end" },

            -- Function call
            ["]F"] = { query = "@call.outer", desc = "Previous function call end" },

            -- Conditional
            ["]I"] = { query = "@conditional.outer", desc = "Previous conditional end" },

            -- Loop
            ["]L"] = { query = "@loop.outer", desc = "Previous loop end" },

            -- Function definition
            ["]M"] = { query = "@function.outer", desc = "Previous function definition end" },
          },
        },
      },
    })

    local ts_repeat_move = require("nvim-treesitter.textobjects.repeatable_move")

    -- vim-way: ; goes to the direction you were moving.
    vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move)
    vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_opposite)

    -- Define repeatable goto next/previous paragraph movements
    local next_paragraph = function()
      vim.cmd("normal! }")
    end
    local previous_paragraph = function()
      vim.cmd("normal! {")
    end
    -- make sure forward function comes first
    local next_paragraph_repeat, prev_paragraph_repeat =
      ts_repeat_move.make_repeatable_move_pair(next_paragraph, previous_paragraph)
    vim.keymap.set({ "n", "x", "o" }, "[p", next_paragraph_repeat, { desc = "Next paragraph" })
    vim.keymap.set({ "n", "x", "o" }, "]p", prev_paragraph_repeat, { desc = "Previous paragraph" })

    -- Make diagnostic navigation repeatable
    -- make sure forward function comes first
    local next_diagnostic_repeat, prev_diagnostic_repeat =
      ts_repeat_move.make_repeatable_move_pair(vim.diagnostic.goto_next, vim.diagnostic.goto_prev)
    vim.keymap.set("n", "[d", next_diagnostic_repeat, { desc = "Next diagnostic" })
    vim.keymap.set("n", "]d", prev_diagnostic_repeat, { desc = "Previous diagnostic" })
  end,
}
