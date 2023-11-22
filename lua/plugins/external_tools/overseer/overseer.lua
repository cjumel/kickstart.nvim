-- overseer.nvim
--
-- A task runner and job management plugin for Neovim.

-- TODO: tasks from vim-dispatch:
-- - pre-commit run file, pre-commit run directory, pre-commit run all files, pre-commit autoupdate
-- - poetry install, poetry update
-- - python run file
-- - pytest, pytest fast, pytest slow

return {
  "stevearc/overseer.nvim",
  keys = {
    {
      "<leader>oo",
      function()
        vim.cmd("OverseerToggle")
      end,
      desc = "[O]verseer: Toggle",
    },
    {
      "<leader>or",
      function()
        vim.cmd("OverseerRun shell")
      end,
      desc = "[O]verseer: [R]un",
    },
    {
      "<leader>ol",
      function()
        local overseer = require("overseer")
        local tasks = overseer.list_tasks({ recent_first = true })
        if vim.tbl_isempty(tasks) then
          vim.notify("No tasks found", vim.log.levels.WARN)
        else
          overseer.run_action(tasks[1], "restart")
        end
      end,
      desc = "[O]verseer: run [L]ast task",
    },
  },
  opts = {
    task_editor = {
      bindings = {
        i = {
          ["<CR>"] = "Submit",
          ["<Tab>"] = false,
          ["<S-Tab>"] = false,
          ["<C-n>"] = "Next",
          ["<C-p>"] = "Prev",
        },
        n = {
          ["<CR>"] = "Submit",
          ["<Tab>"] = false,
          ["<S-Tab>"] = false,
          ["q"] = "Cancel",
          ["<ESC>"] = "Cancel",
          ["?"] = "ShowHelp",
        },
      },
    },
  },
}
