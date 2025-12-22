---@type overseer.TemplateFileProvider
return {
  generator = function()
    if vim.fn.executable("biome") == 0 then
      return {}
    end
    local typescript_utils = require("config.lang_utils.typescript")
    if not typescript_utils.is_project() then
      return {}
    end

    ---@type overseer.TemplateFileDefinition[]
    return {
      {
        name = "biome format --write <file>",
        builder = function()
          ---@type overseer.TaskDefinition
          return { cmd = { "biome", "format", "--write", vim.fn.expand("%:p:.") } }
        end,
        tags = { "FORMAT" },
        condition = { filetype = "typescript" },
      },
      {
        name = "biome check --write <file>",
        builder = function()
          ---@type overseer.TaskDefinition
          return { cmd = { "biome", "check", "--write", vim.fn.expand("%:p:.") } }
        end,
        tags = { "CHECK" },
        condition = { filetype = "typescript" },
      },
      {
        name = "biome check <file>",
        builder = function()
          ---@type overseer.TaskDefinition
          return { cmd = { "biome", "check", vim.fn.expand("%:p:.") } }
        end,
        tags = { "CHECK" },
        condition = { filetype = "typescript" },
      },
      {
        name = "biome format --write <dir>",
        builder = function()
          ---@type overseer.TaskDefinition
          return {
            cmd = {
              "biome",
              "format",
              "--write",
              vim.fn.fnamemodify(require("oil").get_current_dir() --[[@as string]], ":p:."),
            },
          }
        end,
        tags = { "FORMAT" },
        condition = { filetype = "oil" },
      },
      {
        name = "biome check --write <dir>",
        builder = function()
          ---@type overseer.TaskDefinition
          return {
            cmd = {
              "biome",
              "check",
              "--write",
              vim.fn.fnamemodify(require("oil").get_current_dir() --[[@as string]], ":p:."),
            },
          }
        end,
        tags = { "CHECK" },
        condition = { filetype = "oil" },
      },
      {
        name = "biome check <dir>",
        builder = function()
          ---@type overseer.TaskDefinition
          return {
            cmd = {
              "biome",
              "check",
              vim.fn.fnamemodify(require("oil").get_current_dir() --[[@as string]], ":p:."),
            },
          }
        end,
        tags = { "CHECK" },
        condition = { filetype = "oil" },
      },
      {
        name = "biome format",
        builder = function()
          ---@type overseer.TaskDefinition
          return { cmd = { "biome", "format" } }
        end,
        tags = { "FORMAT" },
      },
      {
        name = "biome check --write",
        builder = function()
          ---@type overseer.TaskDefinition
          return { cmd = { "biome", "check", "--write" } }
        end,
        tags = { "CHECK" },
      },
      {
        name = "biome check",
        builder = function()
          ---@type overseer.TaskDefinition
          return { cmd = { "biome", "check" } }
        end,
        tags = { "CHECK" },
      },
    }
  end,
}
