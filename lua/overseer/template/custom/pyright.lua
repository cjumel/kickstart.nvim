---@type overseer.TemplateFileProvider
return {
  generator = function()
    if vim.fn.executable("pyright") == 0 then
      return {}
    end
    local python_utils = require("config.lang_utils.python")
    if not python_utils.is_project() then
      return {}
    end

    ---@type overseer.TemplateFileDefinition[]
    return {
      {
        name = "pyright <file>",
        builder = function()
          ---@type overseer.TaskDefinition
          return { cmd = { "pyright", vim.fn.expand("%:p:.") } }
        end,
        tags = { "CHECK" },
        condition = { filetype = "python" },
      },
      {
        name = "pyright <dir>",
        builder = function()
          ---@type overseer.TaskDefinition
          return {
            cmd = {
              "pyright",
              vim.fn.fnamemodify(require("oil").get_current_dir() --[[@as string]], ":p:."),
            },
          }
        end,
        tags = { "CHECK" },
        condition = { filetype = "oil" },
      },
      {
        name = "pyright",
        builder = function()
          ---@type overseer.TaskDefinition
          return { cmd = { "pyright" } }
        end,
        tags = { "CHECK" },
      },
    }
  end,
}
