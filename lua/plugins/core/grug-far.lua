-- grug-far.nvim
--
-- Find And Replace plugin for neovim.

return {
  "MagicDuck/grug-far.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  keys = {
    {
      "<leader>=",
      function() require("grug-far").open() end,
      desc = "Search and replace",
    },
    {
      "<leader>=",
      function() require("grug-far").with_visual_selection() end,
      mode = { "v" },
      desc = "Search and replace",
    },
  },
  opts = {
    keymaps = {
      replace = { n = "<CR>" },
      qflist = false, -- Doesn't use Trouble's quickfix, so it's not great
      syncLocations = false,
      syncLine = false,
      close = { n = "q" },
      historyOpen = false,
      historyAdd = false,
      refresh = { n = "<localleader>r" },
      openLocation = false, -- Can be replaced by `openLocation` and `openPrevLocation`
      openNextLocation = { n = "," },
      openPrevLocation = { n = ";" },
      gotoLocation = { n = "<Tab>" },
      pickHistoryEntry = false,
      abort = false,
      help = { n = "g?" },
      toggleShowCommand = { n = "<localleader>c" },
      swapEngine = false,
      previewLocation = false,
      swapReplacementInterpreter = false,
      applyNext = { n = "<S-CR>" },
      applyPrev = { n = "<M-CR>" },
    },
  },
}
