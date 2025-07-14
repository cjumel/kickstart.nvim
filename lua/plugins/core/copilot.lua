-- copilot.lua
--
-- Lua and fully-featured version of GitHub Copilot integration in Neovim. Compared to copilot.vim, the official
-- alternative, this plugin is easy to configure and customize. As it is using virtual text, this plugin is nicely
-- complementary with popup-based completion tools, like nvim-cmp. However, copilot.lua (like copilot.vim) requires an
-- active GitHub Copilot subscription and an active internet conection to work.

return {
  "zbirenbaum/copilot.lua",
  cond = Metaconfig.enable_all_plugins or Metaconfig.enable_copilot_plugins,
  -- Spinning the Copilot server a bit before entering insert mode helps providing suggestions right away
  event = { "InsertEnter", "BufNewFile", "BufReadPre" },
  cmd = "Copilot",
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
