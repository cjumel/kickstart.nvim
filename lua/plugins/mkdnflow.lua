-- MKDNFLOW
--
-- Mkdnflow is designed for the fluent navigation of documents and notebooks (AKA "wikis") written in markdown.

local create_user_cmd = function()
  local next_unchecked_checkbox = function()
    vim.cmd("silent!/- [ \\] \\|- [\\-\\] ")
  end
  local previous_unchecked_checkbox = function()
    vim.cmd("silent!?- [ \\] \\|- [\\-\\] ")
  end
  local next_checked_checkbox = function()
    vim.cmd("silent!/- [x\\]")
  end
  local previous_checked_checkbox = function()
    vim.cmd("silent!?- [x\\]")
  end
  local next_heading = function()
    vim.cmd("MkdnNextHeading")
  end
  local previous_heading = function()
    vim.cmd("MkdnPrevHeading")
  end

  local ts_repeat_move = require("nvim-treesitter.textobjects.repeatable_move")
  -- make sure forward function comes first
  local next_unchecked_checkbox_repeat, previous_unchecked_checkbox_repeat =
    ts_repeat_move.make_repeatable_move_pair(next_unchecked_checkbox, previous_unchecked_checkbox)
  local next_checked_checkbox_repeat, previous_checked_checkbox_repeat =
    ts_repeat_move.make_repeatable_move_pair(next_checked_checkbox, previous_checked_checkbox)
  local next_heading_repeat, previous_heading_repeat =
    ts_repeat_move.make_repeatable_move_pair(next_heading, previous_heading)

  vim.api.nvim_create_user_command(
    "MkdnGotoNextUncheckedCheckbox",
    next_unchecked_checkbox_repeat,
    { desc = "Next unchecked checkbox (markdown)" }
  )
  vim.api.nvim_create_user_command(
    "MkdnGotoPreviousUncheckedCheckbox",
    previous_unchecked_checkbox_repeat,
    { desc = "Previous unchecked checkbox (markdown)" }
  )
  vim.api.nvim_create_user_command(
    "MkdnGotoNextCheckedCheckbox",
    next_checked_checkbox_repeat,
    { desc = "Next checked checkbox (markdown)" }
  )
  vim.api.nvim_create_user_command(
    "MkdnGotoPreviousCheckedCheckbox",
    previous_checked_checkbox_repeat,
    { desc = "Previous checked checkbox (markdown)" }
  )
  vim.api.nvim_create_user_command(
    "MkdnGotoNextHeading",
    next_heading_repeat,
    { desc = "Next heading (markdown)" }
  )
  vim.api.nvim_create_user_command(
    "MkdnGotoPreviousHeading",
    previous_heading_repeat,
    { desc = "Previous heading (markdown)" }
  )
end

return {
  "jakewvincent/mkdnflow.nvim",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-treesitter/nvim-treesitter-textobjects",
  },
  keys = {
    {
      "<leader>x",
      function()
        vim.cmd("MkdnToggleToDo")
      end,
      mode = { "n", "v" },
      desc = "[x] Check checkbox",
    },
    {
      "[x",
      function()
        vim.cmd("MkdnGotoNextUncheckedCheckbox")
      end,
      mode = { "n", "x", "o" },
      desc = "Next unchecked checkbox (markdown)",
    },
    {
      "]x",
      function()
        vim.cmd("MkdnGotoPreviousUncheckedCheckbox")
      end,
      mode = { "n", "x", "o" },
      desc = "Previous unchecked checkbox (markdown)",
    },
    {
      "[X",
      function()
        vim.cmd("MkdnGotoNextCheckedCheckbox")
      end,
      mode = { "n", "x", "o" },
      desc = "Next checked checkbox (markdown)",
    },
    {
      "]X",
      function()
        vim.cmd("MkdnGotoPreviousCheckedCheckbox")
      end,
      mode = { "n", "x", "o" },
      desc = "Previous checked checkbox (markdown)",
    },
    {
      "[h",
      function()
        vim.cmd("MkdnGotoNextHeading")
      end,
      mode = { "n", "x", "o" },
      desc = "Next heading (markdown)",
    },
    {
      "]h",
      function()
        vim.cmd("MkdnGotoPreviousHeading")
      end,
      mode = { "n", "x", "o" },
      desc = "Previous heading (markdown)",
    },
  },
  init = function()
    create_user_cmd()
  end,
  config = function()
    create_user_cmd()

    require("mkdnflow").setup({
      modules = {
        bib = false,
        buffers = false,
        conceal = false,
        cursor = true, -- For MkdnNextHeading and MkdnPrevHeading
        folds = false,
        links = false,
        lists = true, -- For MkdnToggleToDo
        maps = false, -- Disable all default mappings
        paths = false,
        tables = false,
        yaml = false,
      },
      wrap = true,
      to_do = {
        -- Using lower "x" enables some synthax highlighting
        symbols = { " ", "-", "x" },
        complete = "x",
      },
    })
  end,
}
