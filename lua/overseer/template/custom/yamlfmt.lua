---@type overseer.TemplateFileProvider
return {
  generator = function()
    if vim.fn.executable("yamlfmt") == 0 then
      return {}
    end
    local fd_cmd = { "fd", "--quiet", "--hidden", "--type", "f", "--extension", "yaml", "--extension", "yml" }
    local fd_result = vim.system(fd_cmd):wait()
    if fd_result.code == 1 then
      return {}
    end

    ---@type overseer.TemplateFileDefinition[]
    return {
      {
        name = "yamlfmt <file>",
        builder = function()
          ---@type overseer.TaskDefinition
          return { cmd = { "yamlfmt", vim.fn.expand("%:p:.") } }
        end,
        tags = { "FORMAT" },
        condition = { filetype = "yaml" },
      },
      {
        name = "yamlfmt <dir>",
        builder = function()
          ---@type overseer.TaskDefinition
          return {
            cmd = {
              "yamlfmt",
              vim.fn.fnamemodify(require("oil").get_current_dir() --[[@as string]], ":p:."),
            },
          }
        end,
        tags = { "FORMAT" },
        condition = { filetype = "oil" },
      },
      {
        name = "yamlfmt <cwd>",
        builder = function()
          ---@type overseer.TaskDefinition
          return { cmd = { "yamlfmt", "." } }
        end,
        tags = { "FORMAT" },
      },
    }
  end,
}
