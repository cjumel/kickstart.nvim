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

local config = {}
local found_neovim_configs = {} -- To keep track of found configurations, for debugging purposes

-- Fetch the default configuration file
-- This file is known in this repository, so it doesn't need to be fetched securely, by opposition with the others,
--  which are git-ignored and could contain malicious code
require("config.default") -- Source the configuration
local default_config = vim.g.neovim_config or {}
config = vim.tbl_deep_extend("force", config, default_config)
found_neovim_configs["default"] = default_config

-- Fetch the global configuration file securely, if it exists
local global_config_path = vim.env.HOME .. "/.config/nvim/.nvim.global.lua"
local global_config_code = vim.secure.read(global_config_path)
if global_config_code ~= nil then -- Configuration file is found and trusted
  load(global_config_code)() -- Source the configuration file code
  local global_config = vim.g.neovim_config or {}
  config = vim.tbl_deep_extend("force", config, global_config)
  found_neovim_configs["global"] = global_config
end

-- Look recursively upward from the cwd until the home directory for a `.nvim.lua` configuration file, and fetch it
--  securely if one is found
local project_config_path = vim.fn.findfile(".nvim.lua", vim.fn.getcwd() .. ";" .. vim.env.HOME)
if project_config_path ~= "" then -- Configuration file is found
  local project_config_code = vim.secure.read(project_config_path)
  if project_config_code ~= nil then -- Configuration file is trusted
    load(project_config_code)() -- Source the configuration file code
    local project_config = vim.g.neovim_config or {}
    config = vim.tbl_deep_extend("force", config, project_config)
    found_neovim_configs["project"] = project_config
  end
end

-- Look for environment variables with keys prefixed by `NVIM_`, followed by the configuration key name in capital 
--  letters. This only work for boolean values ("0", "1", "true", "false"), arrays of strings (comma-separated list) or 
--  strings.
local env_config = {}
for _, key in ipairs(vim.tbl_keys(default_config)) do
  local value = vim.env["NVIM_" .. string.upper(key)]
  if value ~= nil then
    if vim.tbl_contains({ "1", "true" }, string.lower(value)) then
      env_config[key] = true
    elseif vim.tbl_contains({ "0", "false" }, string.lower(value)) then
      env_config[key] = false
    elseif string.find(value, ",") then
      env_config[key] = vim.split(value, ",")
    else
      env_config[key] = value
    end
  end
end
if not vim.tbl_isempty(env_config) then
  config = vim.tbl_deep_extend("force", config, env_config)
  found_neovim_configs["env"] = env_config
end

vim.g.found_neovim_configs = found_neovim_configs

return config
