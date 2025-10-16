return {
  "stevearc/overseer.nvim",
  keys = {
    {
      "<leader>ee",
      function() require("overseer").toggle() end,
      desc = "[E]xecute: toggle task list",
    },
    {
      "<leader>es",
      function() require("overseer").run_template({ name = "shell" }) end,
      desc = "[E]xecute: [S]hell task",
    },
    {
      "<leader>er",
      function()
        require("overseer").run_template({ tags = { "RUN" }, prompt = "avoid", first = false }, function(task, _)
          if task ~= nil then
            require("overseer").open()
          end
        end)
      end,
      desc = "[E]xecute: [R]un task",
    },
    {
      "<leader>eR",
      function()
        require("overseer").run_template({ tags = { "RUN" }, prompt = "always", first = false }, function(task, _)
          if task ~= nil then
            require("overseer").open()
          end
        end)
      end,
      desc = "[E]xecute: [R]un task with parameters",
    },
    {
      "<leader>eb",
      function() require("overseer").run_template({ tags = { "BUILD" }, prompt = "avoid", first = false }) end,
      desc = "[E]xecute: [B]uild task",
    },
    {
      "<leader>eB",
      function() require("overseer").run_template({ tags = { "BUILD" }, prompt = "always", first = false }) end,
      desc = "[E]xecute: [B]uild task with parameters",
    },
    {
      "<leader>ec",
      function() require("overseer").run_template({ tags = { "CHECK" }, prompt = "avoid", first = false }) end,
      desc = "[E]xecute: [C]heck task",
    },
    {
      "<leader>eC",
      function() require("overseer").run_template({ tags = { "CHECK" }, prompt = "always", first = false }) end,
      desc = "[E]xecute: [C]heck task with parameters",
    },
    {
      "<leader>em",
      function() require("overseer").run_template({ tags = { "MAKE" }, prompt = "avoid", first = false }) end,
      desc = "[E]xecute: [M]ake task",
    },
    {
      "<leader>eM",
      function() require("overseer").run_template({ tags = { "MAKE" }, prompt = "always", first = false }) end,
      desc = "[E]xecute: [M]ake task with parameters",
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
      desc = "[E]xecute: [L]ast task",
    },
  },
  opts = {
    templates = { "shell", "custom" },
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
