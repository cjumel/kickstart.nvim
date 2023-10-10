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
      "<leader>tf",
      "/- [ \\] \\|- [\\-\\] <cr>",
      mode = { "n" },
      desc = "[T]odo [F]ind",
    },
    {
      "<leader>tF",
      "/- [x\\] <cr>",
      mode = { "n" },
      desc = "[T]odo [F]ind (done)",
    },
  },
  opts = {
    to_do = {
      -- Using lower "x" enables some synthax highlighting
      symbols = { " ", "-", "x" },
      complete = "x",
    },
  },
  mappings = {
    -- Disable a few default mappings conflicting with other stuff
    MkdnIncreaseHeading = false,
    MkdnDecreaseHeading = false,
    MkdnToggleToDo = false,
  },
}
