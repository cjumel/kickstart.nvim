-- Module to handle flexible Neovim configuration through simple Lua files.
--
-- The default Neovim configuration is defined in `./default.lua` and can be used as template for the other
-- configuration files. A global configuration can be defined in a `.nvim.global.lua` file in the Neovim configuration
-- directory (typically in `~/.config/nvim/`), it will override the default configuration in the whole system.
-- Per-project configurations can be additionally defined, by adding a `.nvim.lua` file in any directory, and it will
-- override all other configurations for any project within this directory or its sub-directories. Finally, additional
-- configuration can be done through environment variables, using the prefix `NVIM_` followed by the configuration name
-- in all capital letters.
--
-- This module takes ideas from:
--  - exrc, a builtin Neovim feature which *securely* sources `.nvim.lua` files for project-level configuration
--    (however, it lacks some flexibility for my use-case, as the `.nvim.lua` file is not sourced at plugin-definition
--    time)
--  - neoconf.nvim, a plugin which handles local & global configurations for Neovim through JSON files, focus on LSP
--    configurations (however, I couldn't make it fit my quite simple use-case, as loading this plugin in the condition
--    of other plugins, at plugin definition time, didn't work)

local nvim_config = {} -- Final, merged configuration
local found_nvim_configs = {} -- To keep track of found configurations

-- Fetch the default configuration file
-- This file is known in this repository, so it doesn't need to be fetched securely, by opposition with the others,
--  which are git-ignored and could contain malicious code
require("nvim_config.default") -- Source the configuration
local default_nvim_config = vim.g.nvim_config or {}
nvim_config = vim.tbl_deep_extend("force", nvim_config, default_nvim_config)
found_nvim_configs["default"] = default_nvim_config

-- Fetch the global configuration file securely, if it exists
local global_nvim_config_path = vim.env.HOME .. "/.config/nvim/.nvim.global.lua"
local global_nvim_config_code = vim.secure.read(global_nvim_config_path)
if global_nvim_config_code ~= nil then -- Configuration file is found and trusted
  load(global_nvim_config_code)() -- Source the configuration file code
  local global_nvim_config = vim.g.nvim_config or {}
  nvim_config = vim.tbl_deep_extend("force", nvim_config, global_nvim_config)
  found_nvim_configs["global"] = global_nvim_config
end

-- Look recursively upward from the cwd until the home directory for a `.nvim.lua` configuration file, and fetch it
--  securely if one is found
local project_nvim_config_path = vim.fn.findfile(".nvim.lua", vim.fn.getcwd() .. ";" .. vim.env.HOME)
if project_nvim_config_path ~= "" then -- Configuration file is found
  local project_nvim_config_code = vim.secure.read(project_nvim_config_path)
  if project_nvim_config_code ~= nil then -- Configuration file is trusted
    load(project_nvim_config_code)() -- Source the configuration file code
    local project_nvim_config = vim.g.nvim_config or {}
    nvim_config = vim.tbl_deep_extend("force", nvim_config, project_nvim_config)
    found_nvim_configs["project"] = project_nvim_config
  end
end

-- Look for environment variables with keys prefixed by `NVIM_`, followed by the configuration key name in capital
--  letters. This only work for boolean values ("0", "1", "true", "false"), arrays of strings (comma-separated list) or
--  strings.
local env_nvim_config = {}
for _, key in ipairs(vim.tbl_keys(default_nvim_config)) do
  local value = vim.env["NVIM_" .. string.upper(key)]
  if value ~= nil then
    if vim.tbl_contains({ "1", "true" }, string.lower(value)) then
      env_nvim_config[key] = true
    elseif vim.tbl_contains({ "0", "false" }, string.lower(value)) then
      env_nvim_config[key] = false
    elseif string.find(value, ",") then
      env_nvim_config[key] = vim.split(value, ",")
    else
      env_nvim_config[key] = value
    end
  end
end
if not vim.tbl_isempty(env_nvim_config) then
  nvim_config = vim.tbl_deep_extend("force", nvim_config, env_nvim_config)
  found_nvim_configs["env"] = env_nvim_config
end

vim.g.nvim_config = nvim_config
vim.g.found_nvim_configs = found_nvim_configs

-- Everything below corresponds to dynamic configuration which is not persisted in the global variables

local function get_project_type_markers_callback(markers)
  return function()
    local cwd = vim.fn.getcwd()
    for _, marker in ipairs(markers) do
      local is_dir_marker = string.sub(marker, -1) == "/"
      if is_dir_marker then
        if vim.fn.isdirectory(cwd .. "/" .. marker) == 1 then
          return true
        end
      else
        if vim.fn.filereadable(cwd .. "/" .. marker) == 1 then
          return true
        end
      end
    end
    return false
  end
end
nvim_config.project_type_markers_callback = {}
for project_type, markers in pairs(nvim_config.project_type_markers) do
  nvim_config.project_type_markers_callback[project_type] = get_project_type_markers_callback(markers)
end

return nvim_config
