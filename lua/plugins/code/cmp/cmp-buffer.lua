-- cmp-buffer
--
-- Nvim-cmp source for buffer words.

return {
  "hrsh7th/cmp-buffer",
  dependencies = {
    "hrsh7th/nvim-cmp",
  },
  event = { "BufNewFile", "BufReadPre" },
  config = function()
    require("cmp").setup({
      sources = {
        { name = "buffer" },
      },
    })
  end,
}
