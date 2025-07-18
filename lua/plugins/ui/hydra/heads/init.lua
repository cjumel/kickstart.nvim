local M = {}

local head_names = {
  "git-conflict",
  "gitsigns",
  "nvim-dap",
  "treewalker",
  "window",
}

local configs = {}

local function setup()
  if not vim.tbl_isempty(configs) then
    return
  end
  for _, name in ipairs(head_names) do
    local ok, config = pcall(require, "plugins.ui.hydra.heads." .. name)
    if not ok then
      vim.warning("Failed to load Hydra config: " .. name)
    else
      table.insert(configs, config)
    end
  end
end

M.get_configs = function()
  setup()
  return configs
end

M.get_keys = function()
  local keys = {}
  for _, config in ipairs(M.get_configs()) do
    table.insert(keys, {
      config.body,
      desc = config.config.desc,
      mode = config.mode or "n",
    })
  end
  return keys
end

return M
