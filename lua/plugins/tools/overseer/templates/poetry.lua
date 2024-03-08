local callback = function(_)
  local cwd = vim.fn.getcwd()
  local file_names = { "poetry.lock", "pyproject.toml" }
  for _, file_name in ipairs(file_names) do
    local file_path = cwd .. "/" .. file_name
    if vim.fn.filereadable(file_path) == 1 then
      return true
    end
  end
  return false
end
local tags = { "python", "poetry" }

return {
  {
    name = "Poetry install",
    condition = {
      callback = callback,
    },
    params = {
      args = {
        type = "string",
        desc = "Additional arguments",
        optional = true,
      },
    },
    builder = function(params)
      return {
        cmd = { "poetry", "install", params.args },
      }
    end,
    tags = tags,
  },
  {
    name = "Poetry update",
    condition = {
      callback = callback,
    },
    params = {
      args = {
        type = "string",
        desc = "Additional arguments",
        optional = true,
      },
    },
    builder = function(params)
      return {
        cmd = { "poetry", "update", params.args },
      }
    end,
    tags = tags,
  },
  {
    name = "Poetry add",
    condition = {
      callback = callback,
    },
    params = {
      package = {
        type = "string",
        desc = "Name of the package to add",
        optional = false,
        order = 1,
      },
      args = {
        type = "string",
        desc = "Additional arguments",
        optional = true,
        order = 2,
      },
    },
    builder = function(params)
      return {
        cmd = { "poetry", "add", params.package, params.args },
      }
    end,
    tags = tags,
  },
}
