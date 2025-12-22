---@type overseer.TemplateFileProvider
return {
  generator = function()
    if vim.fn.executable("mdformat") == 0 then
      return {}
    end
    local fd_cmd = { "fd", "--quiet", "--hidden", "--type", "f", "--extension", "md" }
    local fd_result = vim.system(fd_cmd):wait()
    if fd_result.code == 1 then
      return {}
    end

    ---@type overseer.TemplateFileDefinition[]
    return {
      {
        name = "mdformat <file>",
        builder = function()
          ---@type overseer.TaskDefinition
          return { cmd = { "mdformat", vim.fn.expand("%:p:.") } }
        end,
        tags = { "FORMAT" },
        condition = { filetype = "markdown" },
      },
      {
        name = "mdformat <dir>",
        builder = function()
          ---@type overseer.TaskDefinition
          return {
            cmd = {
              "mdformat",
              vim.fn.fnamemodify(require("oil").get_current_dir() --[[@as string]], ":p:."),
            },
          }
        end,
        tags = { "FORMAT" },
        condition = { filetype = "oil" },
      },
      {
        name = "mdformat <cwd>",
        builder = function()
          ---@type overseer.TaskDefinition
          return { cmd = { "mdformat", "." } }
        end,
        tags = { "FORMAT" },
      },
    }
  end,
}
