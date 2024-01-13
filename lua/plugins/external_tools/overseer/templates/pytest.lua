local utils = require("utils")

return {
  {
    name = "Pytest file",
    tags = { "python", "pytest" },
    builder = function(params)
      local file_path = vim.fn.expand("%:p") -- Current file
      if params.args ~= "" then
        file_path = params.args
      end
      if not utils.path.is_file(file_path) then
        print("Not a file: " .. file_path)
        return {}
      end

      local cmd = { "pytest", file_path }
      local name = "Pytest file"
      local name_suffix = ""
      if params.args ~= "" then
        name_suffix = " (" .. file_path .. ")"
      end

      return {
        cmd = cmd,
        name = name .. name_suffix,
      }
    end,
  },
  {
    name = "Pytest",
    tags = { "python", "pytest" },
    builder = function(params)
      local dir_path = "."
      if params.args ~= "" then
        dir_path = params.args
      end
      if not utils.path.is_directory(dir_path) then
        print("Not a directory: " .. dir_path)
        return {}
      end

      local cmd = { "pytest", dir_path }
      local name = "Pytest"
      local name_suffix = ""
      if params.args ~= "" then
        name_suffix = " (" .. dir_path .. ")"
      end

      return {
        cmd = cmd,
        name = name .. name_suffix,
      }
    end,
    _user_command_nargs = "?",
  },
  {
    name = "Pytest fast",
    tags = { "python", "pytest" },
    builder = function(params)
      local dir_path = "."
      if params.args ~= "" then
        dir_path = params.args
      end
      if not utils.path.is_directory(dir_path) then
        print("Not a directory: " .. dir_path)
        return {}
      end

      local cmd = { "pytest", "-m", "not slow", dir_path }
      local name = "Pytest fast"
      local name_suffix = ""
      if params.args ~= "" then
        name_suffix = " (" .. dir_path .. ")"
      end

      return {
        cmd = cmd,
        name = name .. name_suffix,
      }
    end,
    _user_command_nargs = "?",
  },
  {
    name = "Pytest slow",
    tags = { "python", "pytest" },
    builder = function(params)
      local dir_path = "."
      if params.args ~= "" then
        dir_path = params.args
      end
      if not utils.path.is_directory(dir_path) then
        print("Not a directory: " .. dir_path)
        return {}
      end

      local cmd = { "pytest", "-m", "slow", dir_path }
      local name = "Pytest slow"
      local name_suffix = ""
      if params.args ~= "" then
        name_suffix = " (" .. dir_path .. ")"
      end

      return {
        cmd = cmd,
        name = name .. name_suffix,
      }
    end,
    _user_command_nargs = "?",
  },
}
