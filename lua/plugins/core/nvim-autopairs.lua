-- nvim-autopairs
--
-- A super powerful autopair plugin for Neovim that supports multiple characters.

return {
  "windwp/nvim-autopairs",
  lazy = true, -- Lazy-loading on a custom `InsertEnter` event is defined in `./plugin/autocmds.lua`
  opts = {
    disable_filetype = { "snacks_picker_input", "grug-far" },
  },
}
