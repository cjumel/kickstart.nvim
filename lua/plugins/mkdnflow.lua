-- MKDNFLOW
--
-- Mkdnflow is designed for the fluent navigation of documents and notebooks (AKA "wikis") written in markdown.

return {
  "jakewvincent/mkdnflow.nvim",
  keys = {
    {
      "<leader>cc",
      "<cmd> MkdnToggleToDo <cr>",
      mode = { "n", "v" },
      desc = "[C]heckbox [C]heck",
    },
    {
      "<leader>cf",
      "/- [ \\] \\|- [\\-\\] <cr>",
      mode = { "n" },
      desc = "[C]heckbox [F]ind unchecked",
    },
    {
      "<leader>cF",
      "/- [x\\] <cr>",
      mode = { "n" },
      desc = "[C]heckbox [F]ind checked",
    },
  },
  opts = {
    modules = {
      maps = false, -- Disable all default mappings
    },
    to_do = {
      -- Using lower "x" enables some synthax highlighting
      symbols = { " ", "-", "x" },
      complete = "x",
    },
  },
}
