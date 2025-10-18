return {
  "gbprod/yanky.nvim",
  dependencies = {
    "kkharji/sqlite.lua",
    "folke/snacks.nvim",
  },
  event = { "BufNewFile", "BufReadPre" },
  keys = {
    { "y", "<Plug>(YankyYank)", mode = { "n", "x" }, desc = "Yank" }, -- Preserve cursor position on yank
    { "p", "<Plug>(YankyPutAfter)", mode = { "n", "x" }, desc = "Paste after cursor" },
    { "P", "<Plug>(YankyPutBefore)", mode = { "n", "x" }, desc = "Paste before cursor" },
    { "<C-n>", "<Plug>(YankyPreviousEntry)", desc = "Cycle yank history" },
    { "<C-p>", "<Plug>(YankyNextEntry)", desc = "Cycle yank history backward" },
    {
      "<leader>fy",
      function()
        Snacks.picker.yanky({ ---@diagnostic disable-line: undefined-field
          layout = { preset = "telescope_horizontal" },
          sort = { fields = { "score:desc", "idx" } }, -- Don't sort by item length to preserve recency order
          win = { input = { keys = { ["<CR>"] = { "set_default_register", mode = "i" } } } },
        })
      end,
      desc = "[F]ind: [Y]ank history",
    },
  },
  opts = {
    ring = {
      history_length = 1000,
      storage = "sqlite", -- More stable than "shada"
      update_register_on_cycle = true,
    },
    system_clipboard = { sync_with_ring = false },
    highlight = { timer = 250 },
  },
}
