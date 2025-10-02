-- [[ Automatic Color Column ]]
-- Automatically sets the color column according to `vim.bo.textwidth` (which can be read from a `.editorconfig` file)

local function set_colorcolumn()
  if vim.bo.textwidth ~= 0 then
    vim.opt_local.colorcolumn = tostring(vim.bo.textwidth + 1) -- Offset the column by 1 to put it just after the limit
  end
end
vim.api.nvim_create_autocmd("BufEnter", { callback = set_colorcolumn })
vim.api.nvim_create_autocmd("OptionSet", { pattern = "textwidth", callback = set_colorcolumn })

-- [[ Better InsertEnter lazy-loading ]]
-- This enables lazy-loading plugins on `InsertEnter` event, but skipping prompt buffers like snacks.nvim pickers

local insert_enter_plugins = {
  "copilot.lua",
  "LuaSnip",
  "nvim-autopairs",
  "nvim-cmp",
}
vim.api.nvim_create_autocmd("InsertEnter", {
  callback = function()
    if not vim.g.insert_enter_plugins_loaded and vim.bo.buftype ~= "prompt" then
      require("lazy").load({ plugins = insert_enter_plugins })
      vim.g.insert_enter_plugins_loaded = true
    end
  end,
})
