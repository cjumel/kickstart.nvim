-- overseer.nvim
--
-- Overseer is a task runner and job management plugin for Neovim. It enables running very quickly any kind of job
-- (build, test, formatting, etc.), while also taking into account the project context (e.g. only suggest a `make` job
-- when there is a Makefile, and suggest the relevant commands based on it). It is very easy to use and super
-- configurable, for instance by implementing custom job templates.

return {
  "stevearc/overseer.nvim",
  dependencies = { "williamboman/mason.nvim" }, -- Some tools (e.g. ruff or prettier) require mason.nvim
  keys = {
    { "<leader>xx", function() require("overseer").toggle() end, desc = "E[X]ecute: toggle task list" },
    {
      "<leader>xl",
      function()
        local tasks = require("overseer").list_tasks({ recent_first = true })
        if vim.tbl_isempty(tasks) then
          vim.notify("No tasks found", vim.log.levels.WARN)
        else
          require("overseer").run_action(tasks[1], "restart")
        end
      end,
      desc = "E[X]ecute: rerun [L]ast task",
    },
    {
      "<leader>xs",
      function() require("overseer").run_template({ name = "shell" }) end,
      desc = "E[X]ecute: [S]hell task",
    },
    { "<leader>xa", function() require("overseer").run_template() end, desc = "E[X]ecute: [A]ny task" },
    {
      "<leader>xr",
      function()
        require("overseer").run_template({ tags = { "RUN" }, first = false }, function(task, _)
          if task ~= nil then
            require("overseer").open()
          end
        end)
      end,
      desc = "E[X]ecute: [R]un task",
    },
    {
      "<leader>xt",
      function() require("overseer").run_template({ tags = { "TEST" }, first = false }) end,
      desc = "E[X]ecute: [T]est task",
    },
    {
      "<leader>xc",
      function() require("overseer").run_template({ tags = { "CHECK" }, first = false }) end,
      desc = "E[X]ecute: [C]heck task",
    },
    {
      "<leader>xb",
      function() require("overseer").run_template({ tags = { "BUILD" }, first = false }) end,
      desc = "E[X]ecute: [B]uild task",
    },
  },
  opts = {
    templates = { "shell", "make" },
    dap = false, -- When true, this lazy-loads nvim-dap but I don't use it with overseer.nvim
    task_list = {
      min_height = 0.25, -- Keep a height proportional with window height
      -- Disable conflicting keymaps
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
          ["<Tab>"] = false, -- Important to let Copilot work
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
  },
  config = function(_, opts)
    require("overseer").setup(opts)

    -- Register custom templates
    local template_dir_path = vim.fn.stdpath("config") .. "/lua/plugins/tools/overseer/templates"
    local template_file_paths = vim.split(vim.fn.glob(template_dir_path .. "/*"), "\n")
    for _, template_file_path in ipairs(template_file_paths) do
      local template_file_path_split = vim.split(template_file_path, "/")
      local template_name = template_file_path_split[#template_file_path_split]:gsub("%.lua$", "")
      local template = require("plugins.tools.overseer.templates." .. template_name)
      require("overseer").register_template(template)
    end
  end,
}
