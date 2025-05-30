-- nvim-dap-virtual-text
--
-- This plugin adds virtual text support to nvim-dap, using Treesitter to find variable definitions.

return {
  "theHamsta/nvim-dap-virtual-text",
  lazy = true, -- Lazy-loaded by nvim-dap
  opts = {
    commented = true,
    virt_text_pos = "eol",
  },
}
