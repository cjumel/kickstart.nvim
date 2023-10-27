-- MKDNFLOW
--
-- Mkdnflow is designed for the fluent navigation of documents and notebooks (AKA "wikis") written in markdown.

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
  vim.cmd("silent! MkdnNextHeading")
end
local previous_heading = function()
  vim.cmd("silent! MkdnPrevHeading")
end

return {
  "jakewvincent/mkdnflow.nvim",
  dependencies = {
    "nvim-treesitter/nvim-treesitter-textobjects",
  },
  cmd = {
    "MkdnNextHeading",
    "MkdnPrevHeading",
    "MkdnToggleToDo",
  },
  keys = {
    {
      "<leader>m",
      function()
        vim.cmd("MkdnToggleToDo")
      end,
      ft = "markdown",
      mode = { "n", "v" },
      desc = "[M]ark checkbox",
    },
    {
      "[x",
      function()
        vim.cmd("MkdnNextUncheckedCheckbox")
      end,
      ft = "markdown",
      mode = { "n", "x", "o" },
      desc = "Next unchecked checkbox",
    },
    {
      "]x",
      function()
        vim.cmd("MkdnPrevUncheckedCheckbox")
      end,
      ft = "markdown",
      mode = { "n", "x", "o" },
      desc = "Previous unchecked checkbox",
    },
    {
      "[X",
      function()
        vim.cmd("MkdnNextCheckedCheckbox")
      end,
      ft = "markdown",
      mode = { "n", "x", "o" },
      desc = "Next checked checkbox",
    },
    {
      "]X",
      function()
        vim.cmd("MkdnPrevCheckedCheckbox")
      end,
      ft = "markdown",
      mode = { "n", "x", "o" },
      desc = "Previous checked checkbox",
    },
    {
      "[h",
      function()
        vim.cmd("MkdnNextHeadingRepeat")
      end,
      ft = "markdown",
      mode = { "n", "x", "o" },
      desc = "Next heading",
    },
    {
      "]h",
      function()
        vim.cmd("MkdnPrevHeadingRepeat")
      end,
      ft = "markdown",
      mode = { "n", "x", "o" },
      desc = "Previous heading",
    },
  },
  config = function()
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

    local ts_repeat_move = require("nvim-treesitter.textobjects.repeatable_move")
    local next_unchecked_checkbox_repeat, previous_unchecked_checkbox_repeat =
      ts_repeat_move.make_repeatable_move_pair(next_unchecked_checkbox, previous_unchecked_checkbox)
    local next_checked_checkbox_repeat, previous_checked_checkbox_repeat =
      ts_repeat_move.make_repeatable_move_pair(next_checked_checkbox, previous_checked_checkbox)
    local next_heading_repeat, previous_heading_repeat =
      ts_repeat_move.make_repeatable_move_pair(next_heading, previous_heading)

    vim.api.nvim_create_user_command(
      "MkdnNextUncheckedCheckbox",
      next_unchecked_checkbox_repeat,
      { desc = "Next unchecked checkbox" }
    )
    vim.api.nvim_create_user_command(
      "MkdnPrevUncheckedCheckbox",
      previous_unchecked_checkbox_repeat,
      { desc = "Previous unchecked checkbox" }
    )
    vim.api.nvim_create_user_command(
      "MkdnNextCheckedCheckbox",
      next_checked_checkbox_repeat,
      { desc = "Next checked checkbox" }
    )
    vim.api.nvim_create_user_command(
      "MkdnPrevCheckedCheckbox",
      previous_checked_checkbox_repeat,
      { desc = "Previous checked checkbox" }
    )
    vim.api.nvim_create_user_command(
      "MkdnNextHeadingRepeat",
      next_heading_repeat,
      { desc = "Next heading" }
    )
    vim.api.nvim_create_user_command(
      "MkdnPrevHeadingRepeat",
      previous_heading_repeat,
      { desc = "Previous heading" }
    )
  end,
}
