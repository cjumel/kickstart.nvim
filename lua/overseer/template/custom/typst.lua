---@type overseer.TemplateFileProvider
return {
  generator = function()
    if vim.fn.executable("typst") == 0 then
      return {}
    end

    ---@type overseer.TemplateFileDefinition[]
    return {
      {
        name = "typst compile <file>",
        builder = function()
          ---@type overseer.TaskDefinition
          return { cmd = { "typst", "compile", vim.fn.expand("%:p:.") } }
        end,
        tags = { "BUILD" },
        condition = { filetype = "typst" },
      },
      {
        name = "typst watch <file>",
        builder = function()
          ---@type overseer.TaskDefinition
          return { cmd = { "typst", "watch", vim.fn.expand("%:p:.") } }
        end,
        tags = { "BUILD" },
        condition = { filetype = "typst" },
      },
    }
  end,
}
