-- lsp_signature.nvim
--
-- lsp_signature.nvim is a small plugin improving and making more customizable the LSP signature help. Compared to the
-- alternative I used previously, Noice, it has 2 main advantages: it supports out of the box live signature help as
-- you type, and it adds a virtual text hint which brings information on the current parameter (including the parameter
-- docstring, if the LSP supports it), which can be very nice when there are many parameters or a long docstring.

return {
  "ray-x/lsp_signature.nvim",
  lazy = true,
  opts = {
    hint_prefix = "", -- Remove the emoji from the virual text hint
  },
}
