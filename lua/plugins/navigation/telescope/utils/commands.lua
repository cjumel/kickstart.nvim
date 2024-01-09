local M = {}

M.concatenate_opts = function(opts_1, opts_2)
  local result = {}
  for k, v in pairs(opts_1) do
    result[k] = v
  end
  for k, v in pairs(opts_2) do
    result[k] = v
  end
  return result
end

local function concatenate_arrays(table_1, table_2)
  local result = {}
  for _, value in ipairs(table_1) do
    table.insert(result, value)
  end
  for _, value in ipairs(table_2) do
    table.insert(result, value)
  end
  return result
end

local default_find_command = { -- Default command for fd in telescope implementation
  "fd",
  "--type",
  "f",
  "--color",
  "never",
}

M.find_files_opts = {
  find_command = default_find_command,
  preview = { hide_on_startup = true },
}
M.find_files_hidden_opts = {
  find_command = concatenate_arrays(default_find_command, {
    "--hidden",
    "--exclude",
    ".git",
  }),
  preview = { hide_on_startup = true },
}
M.find_files_all_opts = {
  find_command = concatenate_arrays(default_find_command, {
    "--hidden",
    "--exclude",
    ".git",
    "--no-ignore",
  }),
  preview = { hide_on_startup = true },
}

M.live_grep_opts = {}
M.grep_string_opts = {}

return M
