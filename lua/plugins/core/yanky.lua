-- yanky.nvim
--
-- Improved Yank and Put functionalities for Neovim. This plugin revisits how the yank history can be used and provides
-- several features to make the experience with yanking much more enjoyable than in vanilla Neovim.

return {
  "gbprod/yanky.nvim",
  event = { "BufNewFile", "BufReadPre" },
  keys = {
    { "y", "<Plug>(YankyYank)", mode = { "n", "x" }, desc = "Yank" }, -- Preserve cursor position on yank
    { "p", "<Plug>(YankyPutAfter)", mode = { "n", "x" }, desc = "Paste after cursor" },
    { "P", "<Plug>(YankyPutBefore)", mode = { "n", "x" }, desc = "Paste before cursor" },
    { "gp", "<Plug>(YankyGPutAfter)", mode = { "n", "x" }, desc = "Paste after cursor and move cursor after" },
    { "gP", "<Plug>(YankyGPutBefore)", mode = { "n", "x" }, desc = "Paste before cursor and move cursor after" },
    { "<C-n>", "<Plug>(YankyPreviousEntry)", desc = "Cycle yank history" },
    { "<C-p>", "<Plug>(YankyNextEntry)", desc = "Cycle yank history backward" },
    { '<leader>"', "<cmd>YankyRingHistory<CR>", desc = "Yank history" },
  },
  opts = function()
    return {
      ring = { update_register_on_cycle = true },
      system_clipboard = { sync_with_ring = false },
      highlight = { timer = 250 },
      picker = { select = { action = require("yanky.picker").actions.set_register('"') } },
    }
  end,
}
