-- MKDNFLOW
--
-- Mkdnflow is designed for the fluent navigation of documents and notebooks (AKA "wikis") written
-- in markdown.

local ts_repeat_move = require("nvim-treesitter.textobjects.repeatable_move")
local next_unchecked_checkbox, previous_unchecked_checkbox = ts_repeat_move.make_repeatable_move_pair(
  function()
    vim.cmd("silent!/- [ \\] \\|- [\\-\\] ")
  end,
  function()
    vim.cmd("silent!?- [ \\] \\|- [\\-\\] ")
  end
)
local next_heading, previous_heading = ts_repeat_move.make_repeatable_move_pair(function()
  vim.cmd("silent! MkdnNextHeading")
end, function()
  vim.cmd("silent! MkdnPrevHeading")
end)

return {
  "jakewvincent/mkdnflow.nvim",
  keys = {
    {
      "<leader>m",
      function()
        vim.cmd("MkdnToggleToDo")
      end,
      ft = "markdown",
      mode = { "n", "i", "v" },
      desc = "Mark Markdown checkbox",
    },
    {
      "[X",
      next_unchecked_checkbox,
      ft = "markdown",
      mode = { "n", "x", "o" },
      desc = "Next checkbox (Markdown)",
    },
    {
      "]X",
      previous_unchecked_checkbox,
      ft = "markdown",
      mode = { "n", "x", "o" },
      desc = "Previous checkbox (Markdown)",
    },
    {
      "[T",
      next_heading,
      ft = "markdown",
      mode = { "n", "x", "o" },
      desc = "Next title (Markdown)",
    },
    {
      "]T",
      previous_heading,
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
}
