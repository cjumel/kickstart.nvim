-- Simple machine-, project- and command-level meta-configuration for Neovim in Lua.
--
-- This module tries to address **as simply as possible** an issue I had with configuring Neovim, which is that I wanted
-- to be able to define simple configuration options at various levels:
-- - the machine level, e.g. if I use my Neovim configuration on a machine without logging in with GitHub, I want to
-- disable the GitHub-Copilot-related plugins on that machine;
-- - the project level, e.g. if I work on a project that uses a different code formatter, I want to change the code
-- formatters I use;
-- - the command level, e.g. to start Neovim in "light mode" (basically without any external tool dependenncy)
-- on-the-fly, without having to create a new configuration file.
--
-- When this module is used, the following happens:
-- - First, it looks for a default meta configuration file in `.nvim-default.lua` in the Neovim configuration
-- directory (`~/.config/nvim` by default).
-- - Then, it looks for a global, machine-level meta configuration file in `.nvim-global.lua` in the Neovim
-- configuration directory (`~/.config/nvim` by default).
-- - Then, it looks for a project-specific meta configuration file named `.nvim.lua` in the current working directory
-- and all its parent directories until the home directory. If found, the file is sourced **securely** using
-- `vim.secure.read`, to avoid executing blindly potentially malicious code.
-- - Finally, it looks for environment variables starting with the `NVIM_` prefix.
-- At each of these steps, the newly found configuration options are used to update the meta configuration table,
-- overriding any shared configuration values, to define the final meta configuration table which is then returned by
-- the module.
--
-- This module implements the same features as conf.nvim in https://github.com/cjumel/conf.nvim, but using a local
-- module, instead of the plugin, enables additional syntactic suggar with the use of a global `Metaconfig` variable.

local meta_config = {}

for _, config_name in ipairs({ "default", "global" }) do
  local new_config_path = vim.fn.stdpath("config") .. "/.nvim-" .. config_name .. ".lua"
  if vim.fn.filereadable(new_config_path) == 1 then
    local new_config_code = table.concat(vim.fn.readfile(new_config_path), "\n")
    local new_config = load(new_config_code)()
    meta_config = vim.tbl_deep_extend("force", meta_config, new_config or {})
  end
end

local project_config_path = vim.fn.findfile(
  ".nvim.lua",
  vim.fn.getcwd() .. ";" .. vim.env.HOME -- Look from the cwd upward until the home directory
)
if project_config_path then
  local project_config_code = vim.secure.read(project_config_path)
  if project_config_code ~= nil then -- Configuration file is found and trusted
    local project_config = load(project_config_code)()
    meta_config = vim.tbl_deep_extend("force", meta_config, project_config or {})
  end
end

local env_config = {}
for _, k in ipairs(vim.tbl_keys(meta_config)) do
  local v = vim.env["NVIM_" .. string.upper(k)]
  if v ~= nil then
    if vim.tbl_contains({ "1", "true" }, string.lower(v)) then
      env_config[k] = true
    elseif vim.tbl_contains({ "0", "false" }, string.lower(v)) then
      env_config[k] = false
    elseif string.find(v, ",") then
      env_config[k] = vim.split(v, ",")
    else
      env_config[k] = v
    end
  end
end
meta_config = vim.tbl_deep_extend("force", meta_config, env_config)

vim.api.nvim_create_user_command(
  "MetaconfigOpenDefault",
  function() vim.cmd("edit " .. vim.fn.stdpath("config") .. "/.nvim-default.lua") end,
  { desc = "Open the default meta configuration file" }
)
vim.api.nvim_create_user_command(
  "MetaconfigOpenGlobal",
  function() vim.cmd("edit " .. vim.fn.stdpath("config") .. "/.nvim-global.lua") end,
  { desc = "Open the global meta configuration file" }
)
vim.api.nvim_create_user_command(
  "MetaconfigOpenProject",
  function() vim.cmd("edit " .. project_config_path or vim.fn.getcwd() .. "/.nvim.lua") end,
  { desc = "Open the poject meta configuration file" }
)
vim.api.nvim_create_user_command(
  "MetaconfigShow",
  function() vim.notify(vim.inspect(meta_config), vim.log.levels.INFO, { title = "Meta Configuration" }) end,
  { desc = "Show the final meta configuration" }
)

return meta_config
