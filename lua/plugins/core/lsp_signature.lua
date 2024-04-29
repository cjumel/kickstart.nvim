-- lsp_signature.nvim
--
-- Show function signature as you type.
--
-- This plugins provide 2 features I found useful, compared to the Noice alternative I used previously: it supports out
-- of the box live signature help as you type, whereas in Noice it disappears as soon as you start typing, and the
-- virtual text hint brings information on the current parameter, including its docstring, which is super convenient
-- when they are many parameters or a long docstring.

return {
  "ray-x/lsp_signature.nvim",
  lazy = true,
  opts = {
    hint_prefix = "", -- Remove the emoji from the virual text hint
    hint_inline = function() return false end, -- NOTE: this can be turned on in 0.10 and tested, see if it's better
  },
}
