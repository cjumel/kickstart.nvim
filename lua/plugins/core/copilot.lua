-- copilot.lua
--
-- Fully featured & enhanced replacement for copilot.vim complete with API for interacting with Github Copilot.

return {
  "zbirenbaum/copilot.lua",
  cond = MetaConfig.enable_all_plugins or MetaConfig.enable_copilot_plugins,
  cmd = "Copilot",
  event = { "InsertEnter" },
  opts = {
    panel = { enabled = false }, -- I don't use it & its keymaps conflict with others
    suggestion = {
      auto_trigger = true,
      keymap = {
        accept = false, -- <Tab>, defined in `plugins/keymaps.lua`
        accept_word = false, -- <C-^> (or <C-,> on my keyboard), defined in `plugins/keymaps.lua`
        accept_line = false, -- <C-e>, defined in `plugins/keymaps.lua`
        next = false,
        prev = false,
        dismiss = "<C-x>", -- By default, <C-x> is used mainly for omni-completion, but I don't use it
      },
    },
    filetypes = { yaml = true, markdown = true, gitcommit = true },
  },
}
