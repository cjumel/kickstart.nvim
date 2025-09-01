return {
  "stevearc/overseer.nvim",
  keys = {
    {
      "<leader>ev",
      function() require("overseer").toggle() end,
      desc = "[E]xecute: toggle task [V]iew",
    },
    {
      "<leader>er",
      function()
        require("overseer").run_template({ tags = { "RUN" }, first = false }, function(task, _)
          if task ~= nil then
            require("overseer").open()
          end
        end)
      end,
      desc = "[E]xecute: [R]un tasks",
    },
    {
      "<leader>eb",
      function() require("overseer").run_template({ tags = { "BUILD" }, first = false }) end,
      desc = "[E]xecute: [B]uild tasks",
    },
    {
      "<leader>ec",
      function() require("overseer").run_template({ tags = { "CHECK" }, first = false }) end,
      desc = "[E]xecute: [C]heck tasks",
    },
    {
      "<leader>em",
      function() require("overseer").run_template({ tags = { "MAKE" }, first = false, prompt = "avoid" }) end,
      desc = "[E]xecute: [M]ake tasks",
    },
    {
      "<leader>el",
      function()
        local tasks = require("overseer").list_tasks({ recent_first = true })
        if vim.tbl_isempty(tasks) then
          vim.notify("No tasks found", vim.log.levels.WARN)
        else
          require("overseer").run_action(tasks[1], "restart")
        end
      end,
      desc = "[E]xecute: rerun [L]ast task",
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
