---@type overseer.TemplateFileProvider
return {
  generator = function()
    if vim.fn.executable("stylua") == 0 then
      return {}
    end
    local fd_cmd = { "fd", "--quiet", "--hidden", "--type", "f", "--extension", "lua" }
    local fd_result = vim.system(fd_cmd):wait()
    if fd_result.code == 1 then
      return {}
    end

    ---@type overseer.TemplateFileDefinition[]
    return {
      {
        name = "stylua <file>",
        builder = function()
          ---@type overseer.TaskDefinition
          return { cmd = { "stylua", vim.fn.expand("%:p:.") } }
        end,
        tags = { "FORMAT" },
        condition = { filetype = "lua" },
      },
      {
        name = "stylua <dir>",
        builder = function()
          ---@type overseer.TaskDefinition
          return {
            cmd = {
              "stylua",
              vim.fn.fnamemodify(require("oil").get_current_dir() --[[@as string]], ":p:."),
            },
          }
        end,
        tags = { "FORMAT" },
        condition = { filetype = "oil" },
      },
      {
        name = "stylua <cwd>",
        builder = function()
          ---@type overseer.TaskDefinition
          return { cmd = { "stylua", "." } }
        end,
        tags = { "FORMAT" },
      },
    }
  end,
}
