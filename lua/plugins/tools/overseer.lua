-- overseer.nvim
--
-- A highly configurable task runner and job management plugin for Neovim.

return {
  "stevearc/overseer.nvim",
  keys = {
    { "<leader>mm", function() require("overseer").toggle() end, desc = "Task [M]anager: toggle task list" },
    {
      "<leader>mb",
      function() require("overseer").run_template({ tags = { "BUILD" }, first = false }) end,
      desc = "Task [M]anager: [B]uild tasks",
    },
    {
      "<leader>mr",
      function()
        require("overseer").run_template({ tags = { "RUN" }, first = false }, function(task, _)
          if task ~= nil then
            require("overseer").open()
          end
        end)
      end,
      desc = "Task [M]anager: [R]un tasks",
    },
    {
      "<leader>mc",
      function() require("overseer").run_template({ tags = { "CHECK" }, first = false }) end,
      desc = "Task [M]anager: [C]heck tasks",
    },
    {
      "<leader>mk",
      function() require("overseer").run_template({ tags = { "MAKE" }, first = false }) end,
      desc = "Task [M]anager: Ma[K]e-like tasks",
    },
    {
      "<leader>ml",
      function()
        local tasks = require("overseer").list_tasks({ recent_first = true })
        if vim.tbl_isempty(tasks) then
          vim.notify("No tasks found", vim.log.levels.WARN)
        else
          require("overseer").run_action(tasks[1], "restart")
        end
      end,
      desc = "Task [M]anager: rerun [L]ast task",
    },
  },
  opts = {
    templates = { "custom" },
    dap = false,
    task_list = {
      min_height = 0.25,
      bindings = { ["<C-h>"] = false, ["<C-j>"] = false, ["<C-k>"] = false, ["<C-l>"] = false },
    },
    task_editor = {
      bindings = {
        i = {
          ["<CR>"] = "Submit",
          ["<C-j>"] = "Next", -- <C-n> doesn't work here
          ["<C-k>"] = "Prev", -- <C-p> doesn't work here
          ["<C-c>"] = "Cancel",
          ["<C-s>"] = false,
          ["<Tab>"] = false, -- To let Copilot work
          ["<S-Tab>"] = false,
        },
        n = {
          ["<CR>"] = "Submit",
          [","] = "Next",
          [";"] = "Prev",
          ["<ESC>"] = "Cancel",
          ["q"] = "Cancel",
          ["?"] = "ShowHelp",
          ["<C-s>"] = false,
          ["<Tab>"] = false,
          ["<S-Tab>"] = false,
        },
      },
    },
    default_template_prompt = "always",
    component_aliases = {
      default = {
        { "display_duration", detail_level = 2 },
        "on_output_summarize",
        "on_exit_set_status",
        "custom.notify",
      },
    },
  },
}
