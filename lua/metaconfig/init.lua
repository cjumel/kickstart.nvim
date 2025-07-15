-- Metaconfig
--
-- A module to handle **as simply as possible** machine-, project- and command-level meta-configuration for Neovim. This
-- module has overlapping features with the builtin `exrc` feature, but `exrc` has a few limitations which make it not
-- suited to my purposes (e.g. `exrc` sources the `.nvim.lua` file too late to setup some plugins, or using
-- `vim.g.<name>` doesn't support mixed tables).

local M = {}

local default_config = require("metaconfig.default")
M = vim.tbl_deep_extend("force", M, default_config or {})

local global_config = require("metaconfig.global")
M = vim.tbl_deep_extend("force", M, global_config or {})

local local_config_path = vim.fn.findfile(
  ".nvim.lua",
  vim.fn.getcwd() .. ";" .. vim.env.HOME -- Look from the cwd upward until the home directory
)
if local_config_path then
  local local_config_code = vim.secure.read(local_config_path)
  if local_config_code ~= nil then -- Configuration file is found and trusted
    local local_config = load(local_config_code --[[@as string]])()
    M = vim.tbl_deep_extend("force", M, local_config or {})
  end
end

local env_config = {}
for _, key in ipairs(vim.tbl_keys(M)) do
  local value = vim.env["NVIM_" .. string.upper(key)]
  if value ~= nil then
    if vim.tbl_contains({ "1", "true" }, string.lower(value)) then
      env_config[key] = true
    elseif vim.tbl_contains({ "0", "false" }, string.lower(value)) then
      env_config[key] = false
    else
      error("Invalid value for NVIM_" .. string.upper(key) .. ": " .. value)
    end
  end
end
M = vim.tbl_deep_extend("force", M, env_config)

vim.api.nvim_create_user_command(
  "MetaconfigOpenDefault",
  function() vim.cmd("edit " .. vim.fn.stdpath("config") .. "/lua/metaconfig/default.lua") end,
  { desc = "Open the default meta configuration file" }
)
vim.api.nvim_create_user_command(
  "MetaconfigOpenGlobal",
  function() vim.cmd("edit " .. vim.fn.stdpath("config") .. "/lua/metaconfig/global.lua") end,
  { desc = "Open the global meta configuration file" }
)
vim.api.nvim_create_user_command(
  "MetaconfigOpenProject",
  function() vim.cmd("edit " .. local_config_path or vim.fn.getcwd() .. "/.nvim.lua") end,
  { desc = "Open the poject meta configuration file" }
)
vim.api.nvim_create_user_command(
  "MetaconfigShow",
  function() vim.notify(vim.inspect(M), vim.log.levels.INFO, { title = "Meta Configuration" }) end,
  { desc = "Show the final meta configuration" }
)

return M
