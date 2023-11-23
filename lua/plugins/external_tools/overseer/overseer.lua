-- overseer.nvim
--
-- A task runner and job management plugin for Neovim.

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
        vim.cmd("OverseerRun")
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
    templates = { "shell" },
    task_list = {
      direction = "bottom",
    },
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
  config = function(_, opts)
    local overseer = require("overseer")

    overseer.setup(opts)

    overseer.register_template(require("plugins.external_tools.overseer.templates.pre_commit_run"))
    overseer.register_template(require("plugins.external_tools.overseer.templates.poetry_update"))
  end,
}
