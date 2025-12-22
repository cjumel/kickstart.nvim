---@type overseer.TemplateFileProvider
return {
  generator = function()
    if vim.fn.executable("ruff") == 0 then
      return {}
    end
    local python_utils = require("config.lang_utils.python")
    if not python_utils.is_project() then
      return {}
    end

    ---@type overseer.TemplateFileDefinition[]
    return {
      {
        name = "ruff format <file>",
        builder = function()
          ---@type overseer.TaskDefinition
          return { cmd = { "ruff", "format", vim.fn.expand("%:p:.") } }
        end,
        tags = { "FORMAT" },
        condition = { filetype = "python" },
      },
      {
        name = "ruff check --fix <file>",
        builder = function()
          ---@type overseer.TaskDefinition
          return { cmd = { "ruff", "check", "--fix", vim.fn.expand("%:p:.") } }
        end,
        tags = { "CHECK" },
        condition = { filetype = "python" },
      },
      {
        name = "ruff check <file>",
        builder = function()
          ---@type overseer.TaskDefinition
          return { cmd = { "ruff", "check", vim.fn.expand("%:p:.") } }
        end,
        tags = { "CHECK" },
        condition = { filetype = "python" },
      },
      {
        name = "ruff format <dir>",
        builder = function()
          ---@type overseer.TaskDefinition
          return {
            cmd = {
              "ruff",
              "format",
              vim.fn.fnamemodify(require("oil").get_current_dir() --[[@as string]], ":p:."),
            },
          }
        end,
        tags = { "FORMAT" },
        condition = { filetype = "oil" },
      },
      {
        name = "ruff check --fix <dir>",
        builder = function()
          ---@type overseer.TaskDefinition
          return {
            cmd = {
              "ruff",
              "check",
              "--fix",
              vim.fn.fnamemodify(require("oil").get_current_dir() --[[@as string]], ":p:."),
            },
          }
        end,
        tags = { "CHECK" },
        condition = { filetype = "oil" },
      },
      {
        name = "ruff check <dir>",
        builder = function()
          ---@type overseer.TaskDefinition
          return {
            cmd = {
              "ruff",
              "check",
              vim.fn.fnamemodify(require("oil").get_current_dir() --[[@as string]], ":p:."),
            },
          }
        end,
        tags = { "CHECK" },
        condition = { filetype = "oil" },
      },
      {
        name = "ruff format",
        builder = function()
          ---@type overseer.TaskDefinition
          return { cmd = { "ruff", "format" } }
        end,
        tags = { "FORMAT" },
      },
      {
        name = "ruff check --fix",
        builder = function()
          ---@type overseer.TaskDefinition
          return { cmd = { "ruff", "check", "--fix" } }
        end,
        tags = { "CHECK" },
      },
      {
        name = "ruff check",
        builder = function()
          ---@type overseer.TaskDefinition
          return { cmd = { "ruff", "check" } }
        end,
        tags = { "CHECK" },
      },
    }
  end,
}
