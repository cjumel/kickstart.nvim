return {
  "MagicDuck/grug-far.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  keys = {
    {
      "<leader>r",
      function()
        require("grug-far").open({
          prefills = { paths = vim.bo.filetype == "oil" and require("oil").get_current_dir() or nil },
        })
      end,
      desc = "[R]eplace",
    },
    {
      "<leader>r",
      function()
        require("grug-far").with_visual_selection({
          prefills = { paths = vim.bo.filetype == "oil" and require("oil").get_current_dir() or nil },
        })
      end,
      mode = { "v" },
      desc = "[R]eplace",
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
      openNextLocation = { n = "}" },
      openPrevLocation = { n = "{" },
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
