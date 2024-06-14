-- overseer.nvim
--
-- Overseer is a task runner and job management plugin for Neovim. It enables to run any kind of job (build, test,
-- formatting, etc.) very easily & taking into account the project context (e.g. only suggest a `make` job if there is
-- a `Makefile` & suggest the `make` commands based on it).

-- TODO: some improvements can be made in the Overseer templates:
--  - don't use the template builder as it couples all the templates together & prevents changing the templates
--  - instead of <file> or <dir>, the actual path of file or dir can be passed; it's less pretty but is more consistent
--    with the behavior of the `make` template & will allow later for instance to suggest the tests of all individual
--    functions in a file (like file:function_name)
--  - for pytest, all the arguments can be passed directly in the command instead of through args (it works with the
--    -m "not slow" issue); if there's not reason otherwise, let's make all template like this, otherwise remove the
--    ", " delimiter in the args & use " " instead (prettier)
--  - conditions can be improved (e.g. pytest directory is in `tests/` or pytest file ends with `_test.py`)
--  - (harder) add a new template to sugggest to test all individual functions in a test file, a bit like what's the
--    `make` template does (see its source code)

return {
  "stevearc/overseer.nvim",
  keys = function()
    local overseer = require("overseer")
    return {
      { "<leader>oo", function() overseer.toggle() end, desc = "[O]verseer: toggle" },
      { "<leader>or", function() overseer.run_template({}, overseer.open) end, desc = "[O]verseer: [R]un" },
      { "<leader>ob", function() overseer.run_template({}) end, desc = "[O]verseer: [B]ackground run" },
      { "<leader>os", function() overseer.run_template({ name = "shell" }) end, desc = "[O]verseer: [S]hell" },
      {
        "<leader>ol",
        function()
          local tasks = overseer.list_tasks({ recent_first = true })
          if vim.tbl_isempty(tasks) then
            vim.notify("No tasks found", vim.log.levels.WARN)
          else
            overseer.run_action(tasks[1], "restart")
          end
        end,
        desc = "[O]verseer: rerun [L]ast task",
      },
    }
  end,
  opts = {
    task_list = {
      direction = "bottom", -- Instead of on the left-hand-side
      min_height = 0.25,
      -- Disable bindings conflicting with window navigation
      bindings = { ["<C-h>"] = false, ["<C-j>"] = false, ["<C-k>"] = false, ["<C-l>"] = false },
    },
    task_editor = {
      bindings = {
        i = {
          ["<CR>"] = "Submit",
          ["<C-j>"] = "Next",
          ["<C-k>"] = "Prev",
          ["<C-c>"] = "Cancel",
          ["<Tab>"] = false, -- Disable to let Copilot work
        },
        n = {
          ["<CR>"] = "Submit",
          ["<C-i>"] = "Next",
          ["<C-o>"] = "Prev",
          ["<ESC>"] = "Cancel",
          ["?"] = "ShowHelp",
        },
      },
    },
    default_template_prompt = "always", -- Always ask for parameters if there are any
  },
  config = function(_, opts)
    local overseer = require("overseer")

    overseer.setup(opts)

    -- Register custom templates
    local templates = require("plugins.tools.overseer.templates")
    for _, template in ipairs(templates) do
      overseer.register_template(template)
    end
  end,
}
