-- copilot.lua
--
-- Fully featured & enhanced replacement for copilot.vim complete with API for interacting with Github Copilot.

return {
  "zbirenbaum/copilot.lua",
  cond = MetaConfig.enable_all_plugins or MetaConfig.enable_copilot_plugins,
  cmd = "Copilot",
  init = function() -- Setup custom lazy-loading event
    vim.api.nvim_create_autocmd("InsertEnter", {
      callback = function()
        if vim.bo.buftype == "" then
          Lazy.load({ plugins = { "copilot.lua" } })
        end
      end,
    })
  end,
  opts = {
    panel = { enabled = false }, -- Not used & keymaps create conflicts
    suggestion = {
      auto_trigger = true,
      -- Keymaps for this plugin are defined in ./plugin/keymaps.lua
      keymap = { accept = false, accept_word = false, accept_line = false, next = false, prev = false, dismiss = false },
    },
    filetypes = { yaml = true, markdown = true, gitcommit = true },
  },
}
