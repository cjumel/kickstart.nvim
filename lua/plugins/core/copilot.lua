return {
  "zbirenbaum/copilot.lua",
  lazy = true, -- Lazy-loading on a custom `InsertEnter` event is defined in `./plugin/autocmds.lua`
  opts = {
    panel = { enabled = false }, -- Avoid setting panel-related keymaps
    suggestion = {
      auto_trigger = true,
      keymap = {
        accept = "<Tab>",
        accept_word = "<M-f>",
        accept_line = "<C-e>",
        next = "<M-n>",
        prev = "<M-p>",
        dismiss = "<C-c>",
      },
    },
    should_attach = function(_, _)
      if not MetaConfig.enable_copilot_plugins then
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
