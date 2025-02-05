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
    -- General actions
    { "<leader>oo", function() require("overseer").toggle() end, desc = "[O]verseer: toggle task list" },
    { "<leader>os", function() require("overseer").run_template({ name = "shell" }) end, desc = "[O]verseer: [S]hell" },
    {
      "<leader>ol",
      function()
        local tasks = require("overseer").list_tasks({ recent_first = true })
        if vim.tbl_isempty(tasks) then
          vim.notify("No tasks found", vim.log.levels.WARN)
        else
          require("overseer").run_action(tasks[1], "restart")
        end
      end,
      desc = "[O]verseer: rerun [L]ast task",
    },

    -- Actions to run templates by tags
    { "<leader>oa", function() require("overseer").run_template() end, desc = "[O]verseer: [A]ll templates" },
    {
      "<leader>oA",
      function() require("overseer").run_template({ prompt = "always" }) end,
      desc = "[O]verseer: [A]ll templates (always prompt)",
    },
    {
      "<leader>or",
      function()
        require("overseer").run_template({ tags = { "RUN" }, first = false }, function(task, _)
          if task ~= nil then
            require("overseer").open()
          end
        end)
      end,
      desc = "[O]verseer: [R]un templates",
    },
    {
      "<leader>oR",
      function()
        require("overseer").run_template({ tags = { "RUN" }, first = false, prompt = "always" }, function(task, _)
          if task ~= nil then
            require("overseer").open()
          end
        end)
      end,
      desc = "[O]verseer: [R]un templates (always prompt)",
    },
    {
      "<leader>ot",
      function() require("overseer").run_template({ tags = { "TEST" }, first = false }) end,
      desc = "[O]verseer: [T]est templates",
    },
    {
      "<leader>oT",
      function() require("overseer").run_template({ tags = { "TEST" }, first = false, prompt = "always" }) end,
      desc = "[O]verseer: [T]est templates (always prompt)",
    },
    {
      "<leader>oc",
      function() require("overseer").run_template({ tags = { "CHECK" }, first = false }) end,
      desc = "[O]verseer: [C]heck templates",
    },
    {
      "<leader>oC",
      function() require("overseer").run_template({ tags = { "CHECK" }, first = false, prompt = "always" }) end,
      desc = "[O]verseer: [C]heck templates (always prompt)",
    },
    {
      "<leader>ob",
      function() require("overseer").run_template({ tags = { "BUILD" }, first = false }) end,
      desc = "[O]verseer: [B]uild templates",
    },
    {
      "<leader>oB",
      function() require("overseer").run_template({ tags = { "BUILD" }, first = false, prompt = "always" }) end,
      desc = "[o]verseer: [B]uild templates (always prompt)",
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
    default_template_prompt = "avoid", -- Only show parameter prompt when necessary
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
