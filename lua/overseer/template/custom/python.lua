---@type overseer.TemplateFileProvider
return {
  generator = function()
    if vim.fn.executable("python") == 0 then
      return {}
    end

    ---@type overseer.TemplateFileDefinition[]
    return {
      {
        name = "python -m <module>",
        builder = function()
          ---@type overseer.TaskDefinition
          return { cmd = { "python", "-m", require("config.lang_utils.python").get_module() } }
        end,
        tags = { "RUN" },
        condition = { filetype = { "python" } },
      },
      {
        name = "python <file>",
        builder = function()
          local path = vim.fn.expand("%:p:.")
          ---@type overseer.TaskDefinition
          return { cmd = { "python", path } }
        end,
        tags = { "RUN" },
        condition = { filetype = { "python" } },
      },
    }
  end,
}
