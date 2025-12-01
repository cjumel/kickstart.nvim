return {
  "zbirenbaum/copilot.lua",
  lazy = true, -- Lazy-loading on a custom `InsertEnter` event is defined in `./plugin/autocmds.lua`
  opts = {
    panel = { enabled = false }, -- Avoid setting panel-related keymaps
    suggestion = {
      auto_trigger = true,
      keymap = {
        accept = false, -- Implemented in `./plugin/keymaps.lua` for more control
        accept_word = false, -- Implemented in `./plugin/keymaps.lua` for more control
        accept_line = false, -- Implemented in `./plugin/keymaps.lua` for more control
        next = "<M-n>",
        prev = "<M-p>",
        dismiss = "<C-c>",
      },
    },
    should_attach = function(_, _)
      if not vim.g.enable_gh_copilot_plugins then
        return false
      end
      if not vim.bo.buflisted then
        return false
      end
      if vim.bo.buftype ~= "" then
        return false
      end
      return true
    end,
  },
}
