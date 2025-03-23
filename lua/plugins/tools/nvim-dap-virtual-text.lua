-- nvim-dap-virtual-text
--
-- This plugin adds virtual text support to nvim-dap, using Treesitter to find variable definitions.

return {
  "theHamsta/nvim-dap-virtual-text",
  cond = not Metaconfig.light_mode,
  lazy = true, -- Lazy-loaded through the debug Hydra
  opts = {
    enabled = false, -- I enable this manually with a keymap
    commented = true,
    virt_text_pos = "eol",
  },
}
