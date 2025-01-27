-- copilot.lua
--
-- Lua and fully-featured version of GitHub Copilot integration in Neovim. Compared to copilot.vim, the official
-- alternative, this version is easy to configure and customize, as it is not using pure vimscript. Using virtual text,
-- this plugin is nicely complementary with floating-window completion tools, like nvim-cmp. However, since the model is
-- not run locally, this plugin requires an active internet connection, in addition of an active GitHub Copilot
-- subscription to work.

return {
  "zbirenbaum/copilot.lua",
  cond = not (Metaconfig.light_mode or Metaconfig.disable_copilot),
  -- Spinning the Copilot server a bit before entering insert mode helps to provide suggestions right away
  event = { "InsertEnter", "BufNewFile", "BufReadPre" },
  cmd = "Copilot",
  opts = {
    panel = { enabled = false }, -- I don't use it & its keymaps conflict with others
    suggestion = {
      auto_trigger = true,
      -- Copilot.lua keymaps are implemented in `plugins/keymaps.lua`, so let's disable all default keymaps
      keymap = { accept = false, accept_word = false, accept_line = false, next = false, prev = false, dismiss = false },
    },
    filetypes = { yaml = true, markdown = true, gitcommit = true },
  },
}
