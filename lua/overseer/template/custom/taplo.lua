---@type overseer.TemplateFileProvider
return {
  generator = function()
    if vim.fn.executable("taplo") == 0 then
      return {}
    end
    local fd_cmd = { "fd", "--quiet", "--hidden", "--type", "f", "--extension", "toml" }
    local fd_result = vim.system(fd_cmd):wait()
    if fd_result.code == 1 then
      return {}
    end

    ---@type overseer.TemplateFileDefinition[]
    return {
      {
        name = "taplo fmt <file>",
        builder = function()
          ---@type overseer.TaskDefinition
          return { cmd = { "taplo", "fmt", vim.fn.expand("%:p:.") } }
        end,
        tags = { "FORMAT" },
        condition = { filetype = "toml" },
      },
      {
        name = "taplo fmt <dir>",
        builder = function()
          ---@type overseer.TaskDefinition
          return {
            cmd = {
              "taplo",
              "fmt",
              vim.fn.fnamemodify(require("oil").get_current_dir() --[[@as string]], ":p:."),
            },
          }
        end,
        tags = { "FORMAT" },
        condition = { filetype = "oil" },
      },
      {
        name = "taplo fmt",
        builder = function()
          ---@type overseer.TaskDefinition
          return { cmd = { "taplo", "fmt" } }
        end,
        tags = { "FORMAT" },
      },
    }
  end,
}
