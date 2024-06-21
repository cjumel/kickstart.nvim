-- nvim-ufo
--
-- nvim-ufo makes Neovim's fold look modern and keep high performance. While the builtin folds can be configured to use
-- Treesitter & keep the highlights of folded lines, which are two important features, they are not as user friendly as
-- with nvim-ufo, both in terms of visual and usage. nvim-ufo provides a better fold visual (keep highlights & add a
-- symbol to represent the fold), has a better support of Treesitter folding, supports several folding methods at once,
-- or provide the ability to peek inside a fold, for instance. All these features make nvim-ufo a very nice addition to
-- Neovim with a seamless integration.

return {
  "kevinhwang91/nvim-ufo",
  dependencies = { "kevinhwang91/promise-async" },
  event = "VeryLazy", -- For some reason, using `{ "BufNewFile", "BufReadPre" }` doesn't work
  init = function()
    vim.o.foldcolumn = "0" -- Disable fold level column
    vim.o.foldlevel = 99 -- nvim-ufo requires large fold level values
    vim.o.foldlevelstart = 99 -- nvim-ufo requires large fold level values
    vim.o.foldenable = true -- Enable folding when opening a file
  end,
  opts = {
    open_fold_hl_timeout = 0, -- Disable highlighting folds when opening
    provider_selector = function(_, _, _) -- Define the folding providers
      return {
        "treesitter", -- Main provider
        "indent", -- Fallback to indent-level
      }
    end,
    preview = { win_config = { winblend = 0 } }, -- Preview transparency messes up colors with transparent backgrounds
  },
  config = function(_, opts)
    local ufo = require("ufo")
    local preview_floatwin = require("ufo.preview.floatwin")

    ufo.setup(opts)

    -- nvim-ufo requires to remap `zR` & `zM` to open/close all folds
    vim.keymap.set("n", "zR", ufo.openAllFolds, { desc = "Open all folds" })
    vim.keymap.set("n", "zM", ufo.closeAllFolds, { desc = "Close all folds" })
    -- The builtin `zr` & `zm` don't work with nvim-ufo, so let's remap them (but also change their behavior)
    vim.keymap.set("n", "zr", ufo.openFoldsExceptKinds, { desc = "Open folds almost all folds" })
    vim.keymap.set("n", "zm", ufo.closeFoldsWith, { desc = "Close folds at count level" })

    --- Define a custom hover keymap, to preview folds when on a folded line, or fall back to LSP hovering
    vim.keymap.set("n", "K", function()
      local winid = nil
      if preview_floatwin.winid == nil then -- Peek window is not already opened
        winid = ufo.peekFoldedLinesUnderCursor(false, false) -- Try to open peek window
      else
        winid = ufo.peekFoldedLinesUnderCursor(true, false) -- Enter in peek window
      end

      if not winid then -- Cursor was not on a folded line
        vim.lsp.buf.hover() -- Hover with the LSP
      end
    end, { desc = "Hover" })
  end,
}
