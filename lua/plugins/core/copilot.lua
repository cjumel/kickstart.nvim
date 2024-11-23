-- copilot.lua
--
-- Lua and fully-featured version of GitHub Copilot integration in Neovim. Compared to copilot.vim, the official
-- alternative, this version is easy to configure and customize, as it is not using pure vimscript. Using virtual text,
-- this plugin is nicely complementary with floating-window completion tools, like nvim-cmp. However, since the model is
-- not run locally, this plugins require an active internet connection, in addition of an active GitHub Copilot
-- subscription to work.

local nvim_config = require("nvim_config")

return {
  "zbirenbaum/copilot.lua",
  cond = not (nvim_config.light_mode or nvim_config.disable_copilot),
  -- When lazy-loading on InsertEnter, the plugin doesn't work right away (just like copilot.vim)
  event = { "BufNewFile", "BufReadPre" },
  cmd = "Copilot",
  opts = {
    panel = { enabled = false }, -- I don't use Copilot panel & its keymaps will conflict with others
    suggestion = {
      auto_trigger = true, -- Don't require to use next/prev suggestion keymap to trigger Copilot completion
      -- Disable all keymaps as they are implemented in `plugins/keymaps.lua`, since they are mixed with regular
      -- features (moving cursor in insert mode), and to prevent any conflict
      keymap = { accept = false, accept_word = false, accept_line = false, next = false, prev = false, dismiss = false },
    },
    filetypes = { yaml = true, markdown = true }, -- Enable Copilot on additional filetypes
  },
}
