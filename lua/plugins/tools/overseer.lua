-- TODO: for "CHECK" tasks, send issues to diagnostics and qflist
return {
  "stevearc/overseer.nvim",
  dependencies = { "mason-org/mason.nvim" },
  keys = {
    { "<leader>ee", function() require("overseer").toggle() end, desc = "[E]xecute: toggle task list" },
    {
      "<leader>er",
      function()
        require("overseer").run_task({ tags = { "RUN" }, first = false }, function(task)
          if task ~= nil then
            require("overseer").open()
          end
        end)
      end,
      desc = "[E]xecute: [R]un task",
    },
    {
      "<leader>eb",
      function() require("overseer").run_task({ tags = { "BUILD" }, first = false }) end,
      desc = "[E]xecute: [B]uild task",
    },
    {
      "<leader>eB",
      function() require("overseer").run_task({ tags = { "BUILD" }, first = false, params = { prompt = true } }) end,
      desc = "[E]xecute: [B]uild task with arguments",
    },
    {
      "<leader>ef",
      function() require("overseer").run_task({ tags = { "FORMAT" }, first = false }) end,
      desc = "[E]xecute: [F]ormat task",
    },
    {
      "<leader>eF",
      function() require("overseer").run_task({ tags = { "FORMAT" }, first = false, params = { prompt = true } }) end,
      desc = "[E]xecute: [F]ormat task with arguments",
    },
    {
      "<leader>ec",
      function() require("overseer").run_task({ tags = { "CHECK" }, first = false }) end,
      desc = "[E]xecute: [C]heck task",
    },
    {
      "<leader>eC",
      function() require("overseer").run_task({ tags = { "CHECK" }, first = false, params = { prompt = true } }) end,
      desc = "[E]xecute: [C]heck task with arguments",
    },
    {
      "<leader>em",
      function() require("overseer").run_task({ tags = { "MAKE" }, first = false }) end,
      desc = "[E]xecute: [M]ake task",
    },
    {
      "<leader>eM",
      function() require("overseer").run_task({ tags = { "MAKE" }, first = false, params = { prompt = true } }) end,
      desc = "[E]xecute: [M]ake task with arguments",
    },
    {
      "<leader>el",
      function()
        local tasks = require("overseer").list_tasks({ recent_first = true })
        if vim.tbl_isempty(tasks) then
          vim.notify("No tasks found", vim.log.levels.WARN, { title = "overseer.nvim" })
        else
          local task = tasks[1]
          ---@diagnostic disable-next-line: invisible
          task.from_template.params.prompt = false -- Custom arguments are already included in `task`
          require("overseer").run_action(task, "restart")
        end
      end,
      desc = "[E]xecute: [L]ast task",
    },
  },
  opts = {
    dap = false, -- Lazy-load nvim-dap but I don't use the integration
    task_list = {
      min_height = 0.25,
      keymaps = { ["<C-j>"] = false, ["<C-k>"] = false }, -- Don't override window navigation
    },
    component_aliases = {
      default = {
        "on_exit_set_status",
        "custom.on_pre_start_prompt",
        "custom.on_start_notify",
        "custom.on_complete_notify",
      },
    },
  },
}
