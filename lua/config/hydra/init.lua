local M = {}

local head_names = {
  "git-conflict",
  "gitsigns",
  "nvim-dap",
  "treewalker",
  "window",
}

M.configs = {}

M.is_setup = function() return not vim.tbl_isempty(M.configs) end

M.setup = function()
  if M.is_setup() then
    return
  end
  for _, name in ipairs(head_names) do
    local ok, config = pcall(require, "config.hydra." .. name)
    if not ok then
      vim.warning("Failed to load Hydra config: " .. name)
    else
      table.insert(M.configs, config)
    end
  end
end

M.get_configs = function()
  M.setup()
  return M.configs
end

M.get_keys = function()
  local configs = M.get_configs()
  local keys = {}
  for _, config in ipairs(configs) do
    table.insert(keys, {
      config.body,
      desc = config.config.desc,
      mode = config.mode or "n",
    })
  end
  return keys
end

return M
