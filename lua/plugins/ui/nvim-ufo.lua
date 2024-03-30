-- nvim-ufo
--
-- Make Neovim's fold look modern and keep high performance.

return {
  "kevinhwang91/nvim-ufo",
  dependencies = {
    "kevinhwang91/promise-async",
    "nvim-treesitter/nvim-treesitter", -- For treesitter provider
  },
  event = "VeryLazy", -- { "BufNewFile", "BufReadPre" } doesn't work
  init = function()
    -- Using ufo requires large fold level values
    vim.o.foldlevel = 99
    vim.o.foldlevelstart = 99
  end,
  keys = {
    {
      "zR",
      function() require("ufo").openAllFolds() end,
      desc = "Open all folds",
    },
    {
      "zM",
      function() require("ufo").closeAllFolds() end,
      desc = "Close all folds",
    },
  },
  opts = {
    open_fold_hl_timeout = 0, -- Disable highlighting of opened folds
    provider_selector = function(_, _, _)
      return {
        "treesitter", -- Main provider
        "indent", -- Fallback to indent-level
      }
    end,
    preview = {
      win_config = {
        winblend = 0, -- Preview colors are messed up with transparency
      },
    },
  },
}
