-- copilot.lua
--
-- Fully featured & enhanced replacement for copilot.vim complete with API for interacting with Github Copilot.

return {
  "zbirenbaum/copilot.lua",
  cond = MetaConfig.enable_all_plugins or MetaConfig.enable_copilot_plugins,
  lazy = true, -- Lazy-loading on a custom `InsertEnter` event is defined in `./plugin/autocmds.lua`
  opts = {
    panel = { enabled = false }, -- Not used & keymaps create conflicts
    suggestion = {
      auto_trigger = true,
      -- Keymaps are defined in `./plugin/keymaps.lua`, since they mix Copilot.lua features with others
      keymap = { accept = false, accept_word = false, accept_line = false, next = false, prev = false, dismiss = false },
    },
    filetypes = { yaml = true, markdown = true, gitcommit = true },
  },
}
