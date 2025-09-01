return {
  "windwp/nvim-autopairs",
  lazy = true, -- Lazy-loading on a custom `InsertEnter` event is defined in `./plugin/autocmds.lua`
  opts = {
    disable_filetype = { "snacks_picker_input", "grug-far" },
  },
}
