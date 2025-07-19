-- grug-far.nvim
--
-- grug-far.nvim is a find and replace plugin for Neovim. It provides a very simple interface using the full power
-- of ripgrep, while trying to be as user-friendly as possible, making it easier and more powerful to use than Neovim
-- builtin features, while not replacing them altogether. For instance, for range substitution, Neovim's search and
-- replace remains effective, even more when combined with a plugin like substitute.nvim.

return {
  "MagicDuck/grug-far.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  keys = {
    {
      "<leader>rr",
      function()
        require("grug-far").open({
          prefills = { paths = vim.bo.filetype == "oil" and require("oil").get_current_dir() or nil },
        })
      end,
      desc = "[R]eplace: unrestricted",
    },
    {
      "<leader>rr",
      function()
        require("grug-far").with_visual_selection({
          prefills = { paths = vim.bo.filetype == "oil" and require("oil").get_current_dir() or nil },
        })
      end,
      mode = { "v" },
      desc = "[R]eplace: unrestricted",
    },
    {
      "<leader>rb",
      function() require("grug-far").open({ prefills = { paths = vim.fn.expand("%") } }) end,
      desc = "[R]eplace: in [B]uffer",
    },
    {
      "<leader>rb",
      function() require("grug-far").with_visual_selection({ prefills = { paths = vim.fn.expand("%") } }) end,
      mode = { "v" },
      desc = "[R]eplace: in [B]uffer",
    },
    {
      "<leader>rf",
      function()
        require("grug-far").open({
          prefills = {
            filesFilter = "*." .. vim.bo.filetype,
            paths = vim.bo.filetype == "oil" and require("oil").get_current_dir() or nil,
          },
        })
      end,
      desc = "[R]eplace: with same [F]iletype",
    },
    {
      "<leader>rf",
      function()
        require("grug-far").with_visual_selection({
          prefills = {
            filesFilter = "*." .. vim.bo.filetype,
            paths = vim.bo.filetype == "oil" and require("oil").get_current_dir() or nil,
          },
        })
      end,
      mode = { "v" },
      desc = "[R]eplace: with same [F]iletype",
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
