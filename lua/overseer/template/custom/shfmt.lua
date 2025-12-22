---@type overseer.TemplateFileProvider
return {
  generator = function()
    if vim.fn.executable("shfmt") == 0 then
      return {}
    end
    local fd_cmd = { "fd", "--quiet", "--hidden", "--type", "f", "--extension", "sh", "--extension", "zsh" }
    local fd_result = vim.system(fd_cmd):wait()
    if fd_result.code == 1 then
      return {}
    end

    ---@type overseer.TemplateFileDefinition[]
    return {
      {
        name = "shfmt --write <file>",
        builder = function()
          ---@type overseer.TaskDefinition
          return { cmd = { "shfmt", "--write", vim.fn.expand("%:p:.") } }
        end,
        tags = { "FORMAT" },
        condition = { filetype = { "sh", "zsh" } },
      },
      {
        name = "shfmt --write <dir>",
        builder = function()
          ---@type overseer.TaskDefinition
          return {
            cmd = {
              "shfmt",
              "--write",
              vim.fn.fnamemodify(require("oil").get_current_dir() --[[@as string]], ":p:."),
            },
          }
        end,
        tags = { "FORMAT" },
        condition = { filetype = "oil" },
      },
      {
        name = "shfmt --write <cwd>",
        builder = function()
          ---@type overseer.TaskDefinition
          return { cmd = { "shfmt", "--write", "." } }
        end,
        tags = { "FORMAT" },
      },
    }
  end,
}
