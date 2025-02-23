-- nvim-autopairs
--
-- nvim-autopairs is a simple, yet powerful plugin to automatically insert a closing bracket when the opening one is
-- typed, or to insert a pair of brackets when completion is triggered with a function, for instance. It can be easily
-- customized, but comes with great defaults for me.

return {
  "windwp/nvim-autopairs",
  event = { "InsertEnter" },
  opts = {
    disable_filetype = { "snacks_picker_input", "grug-far" },
  },
}
