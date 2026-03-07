return {
  "zbirenbaum/copilot.lua",
  cmd = { "Copilot" }, -- Lazy-loading on a custom `InsertEnter` event is also defined in `./plugin/autocmds.lua`
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
      ---@type nvim_config.EnableGhCopilotPlugins
      local enable_gh_copilot_plugins = vim.g.enable_gh_copilot_plugins or false
      if not enable_gh_copilot_plugins or not vim.bo.buflisted or vim.bo.buftype ~= "" then
        return false
      end
      return true
    end,
    server = { type = "binary" }, -- Avoid issues with Node.js versions (like nvm using a too old one)
  },
}
