-- overseer.nvim
--
-- Overseer is a task runner and job management plugin for Neovim. It enables running very quickly any kind of job
-- (build, test, formatting, etc.), while also taking into account the project context (e.g. only suggest a `make` job
-- when there is a Makefile, and suggest the relevant commands based on it). It is very easy to use and super
-- configurable, for instance by implementing custom job templates.

local actions = require("plugins.tools.overseer.actions")

return {
  "stevearc/overseer.nvim",
  dependencies = { "williamboman/mason.nvim" }, -- Some tools (e.g. ruff or prettier) require mason.nvim
  keys = {
    { "<leader>oo", actions.toggle_task_list, desc = "[O]verseer: toggle task list" },
    { "<leader>oa", actions.all_templates, desc = "[O]verseer: [A]ll templates" },
    { "<leader>op", actions.all_templates_with_prompt, desc = "[O]verseer: all templates with [P]rompt" },
    { "<leader>os", actions.shell_template, desc = "[O]verseer: [S]hell template" },
    { "<leader>or", actions.run_templates, desc = "[O]verseer: [R]un templates" },
    { "<leader>ot", actions.test_templates, desc = "[O]verseer: [T]est templates" },
    { "<leader>oc", actions.check_templates, desc = "[O]verseer: [C]heck templates" },
    { "<leader>ob", actions.build_templates, desc = "[O]verseer: [B]uild templates" },
    { "<leader>ol", actions.rerun_last_task, desc = "[O]verseer: rerun [L]ast task" },
  },
  opts = {
    templates = {
      "shell",
      "make",
    },
    dap = false, -- When true, this lazy-loads nvim-dap but I don't use it with overseer.nvim
    task_list = {
      min_height = 0.25, -- Keep a height proportional with window height
      -- Disable the builtin keymaps in conflict with window navigation keymaps
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
