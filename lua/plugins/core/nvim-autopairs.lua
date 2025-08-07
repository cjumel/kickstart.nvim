-- nvim-autopairs
--
-- A super powerful autopair plugin for Neovim that supports multiple characters.

return {
  "windwp/nvim-autopairs",
  event = { "InsertEnter" },
  opts = {
    disable_filetype = { "snacks_picker_input", "grug-far" },
  },
}
