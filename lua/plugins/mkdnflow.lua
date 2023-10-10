-- MKDNFLOW
--
-- Mkdnflow is designed for the fluent navigation of documents and notebooks (AKA "wikis") written in markdown.

return {
  "jakewvincent/mkdnflow.nvim",
  keys = {
    {
      "<leader>tt",
      "<cmd> MkdnToggleToDo <cr>",
      mode = { "n", "v" },
      desc = "[T]odo [T]oggle",
    },
    {
      "<leader>tn",
      "/[ \\] <cr>",
      mode = { "n" },
      desc = "[T]odo find [N]ot started",
    },
    {
      "<leader>tw",
      "/[-\\] <cr>",
      mode = { "n" },
      desc = "[T]odo find [W]IP",
    },
    {
      "<leader>td",
      "/[x\\] <cr>",
      mode = { "n" },
      desc = "[T]odo find [D]one",
    },
  },
  opts = {
    to_do = {
      -- Using lower "x" enables some synthax highlighting
      symbols = { " ", "-", "x" },
      complete = "x",
    },
  },
}
