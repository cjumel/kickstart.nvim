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
    {
      "<leader>R",
      function() require("grug-far").open({ prefills = { paths = vim.fn.expand("%") } }) end,
      desc = "[R]eplace in buffer",
    },
    {
      "<leader>R",
      function() require("grug-far").with_visual_selection({ prefills = { paths = vim.fn.expand("%") } }) end,
      mode = { "v" },
      desc = "[R]eplace in buffer",
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
      applyPrev = false,
    },
  },
  config = function(_, opts)
    local grug_far = require("grug-far")
    grug_far.setup(opts)

    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("GrugFarKeymaps", { clear = true }),
      pattern = { "grug-far" },
      callback = function()
        ---@param lhs string The left-hand side of the keymap.
        ---@param rhs string|function The right-hand side of the keymap.
        ---@param desc string The description of the keymap.
        local function map(lhs, rhs, desc) vim.keymap.set("n", lhs, rhs, { desc = desc, buffer = true }) end

        map("<localleader>h", function()
          ---@diagnostic disable-next-line: param-type-mismatch
          local state = unpack(grug_far.toggle_flags({ "--hidden" }))
          vim.notify("grug-far: toggled --hidden " .. (state and "ON" or "OFF"))
        end, "Toggle --hidden flag")
        map("<localleader>f", function()
          ---@diagnostic disable-next-line: param-type-mismatch
          local state = unpack(grug_far.toggle_flags({ "--fixed-strings" }))
          vim.notify("grug-far: toggled --fixed-strings " .. (state and "ON" or "OFF"))
        end, "Toggle --fixed-strings flag")
      end,
    })
  end,
}
