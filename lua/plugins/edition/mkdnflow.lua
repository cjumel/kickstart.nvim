-- MKDNFLOW
--
-- Mkdnflow is designed for the fluent navigation of documents and notebooks (AKA "wikis") written in markdown.

local next_unchecked_checkbox = function()
  vim.cmd("silent!/- [ \\] \\|- [\\-\\] ")
end
local previous_unchecked_checkbox = function()
  vim.cmd("silent!?- [ \\] \\|- [\\-\\] ")
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
  keys = {
    {
      "<C-m>",
      function()
        vim.cmd("MkdnToggleToDo")
      end,
      ft = "markdown",
      mode = { "n", "v" },
      desc = "Mark checkbox (Markdown)",
    },
    {
      "[X",
      function()
        vim.cmd("MkdnNextUncheckedCheckbox")
      end,
      ft = "markdown",
      mode = { "n", "x", "o" },
      desc = "Next checkbox (Markdown)",
    },
    {
      "]X",
      function()
        vim.cmd("MkdnPrevUncheckedCheckbox")
      end,
      ft = "markdown",
      mode = { "n", "x", "o" },
      desc = "Previous checkbox (Markdown)",
    },
    {
      "[T",
      function()
        vim.cmd("MkdnNextHeadingRepeat")
      end,
      ft = "markdown",
      mode = { "n", "x", "o" },
      desc = "Next title (Markdown)",
    },
    {
      "]T",
      function()
        vim.cmd("MkdnPrevHeadingRepeat")
      end,
      ft = "markdown",
      mode = { "n", "x", "o" },
      desc = "Previous title (Markdown)",
    },
  },
  opts = {
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
  },
  config = function(_, opts)
    require("mkdnflow").setup(opts)

    local ts_repeat_move = require("nvim-treesitter.textobjects.repeatable_move")
    local next_unchecked_checkbox_repeat, previous_unchecked_checkbox_repeat =
      ts_repeat_move.make_repeatable_move_pair(next_unchecked_checkbox, previous_unchecked_checkbox)
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
