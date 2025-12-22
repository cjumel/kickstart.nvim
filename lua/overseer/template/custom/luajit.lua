---@type overseer.TemplateFileProvider
return {
  generator = function()
    if vim.fn.executable("luajit") == 0 then
      return {}
    end

    ---@type overseer.TemplateFileDefinition[]
    return {
      {
        name = "luajit <file>",
        builder = function()
          ---@type overseer.TaskDefinition
          return { cmd = { "luajit", vim.fn.expand("%:p:.") } }
        end,
        tags = { "RUN" },
        condition = { filetype = { "lua" } },
      },
    }
  end,
}
