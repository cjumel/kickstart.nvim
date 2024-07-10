-- lualine.nvim
--
-- A blazing fast and customizable status bar written in Lua.

local extensions = require("plugins.ui.lualine.extensions")
local sections = require("plugins.ui.lualine.sections")
local theme = require("theme")

return {
  "nvim-lualine/lualine.nvim",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
    -- FIXME: for some reason, `require("harpoon")` doesn't lazy-load Harpoon anymore, leading to issues with the
    --  Lualine module & when using it on Oil buffers; the Harpoon dependency can be removed once this issue is fixed
    "ThePrimeagen/harpoon",
  },
  priority = 100, -- Main UI stuff should be loaded first
  init = function()
    -- Don't show Neovim mode in status line as it is redundant with Lualine's onw feature
    -- This can be re-enabled in the `config` for status lines missing the corresponding feature, with the custom
    -- parameter `_keep_showmode`
    vim.opt.showmode = false
  end,
  opts = theme.make_opts("lualine", {
    options = {
      icons_enabled = true,
      theme = "auto",
      component_separators = "",
      section_separators = "",
      globalstatus = true, -- Use a single global status line for all splits (precedes `vim.o.laststatus`)
      refresh = { statusline = 50 }, -- Decrease refresh rate to make modules more responsive (e.g. Harpoon's)
    },
    sections = sections.default,
    extensions = extensions.build_extensions(sections.default),
  }),
  config = function(_, opts)
    local lualine = require("lualine")

    lualine.setup(opts)

    if opts._keep_showmode then
      vim.opt.showmode = true -- Show Neovim status in status line

      -- Prevent Lualine to show insert mode after a Telescope insert-mode search when `vim.opt.showmode = true`
      -- This fixes an issue which might be related to https://github.com/nvim-telescope/telescope.nvim/issues/2995, and
      --  the fix was taken from https://github.com/nvim-telescope/telescope.nvim/issues/2766; it can be removed once
      --  the issue is not observed anymore, but it doesn't hurt much.
      -- To reproduce the issue:
      --  - open Neovim with `vim.opt.showmode = true` (default value)
      --  - trigger the LSP progress computation and wait for it to be finished as it prevents the issue from appearing
      --  - open a file with Telescope in insert mode
      --  - the Lualine should show the insert mode indicator (while not actually being in insert mode)
      vim.api.nvim_create_autocmd("WinLeave", {
        callback = function()
          if vim.bo.ft == "TelescopePrompt" and vim.fn.mode() == "i" then
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes([[<C-\><C-n>]], true, false, true), "i", false)
          end
        end,
      })
    end
  end,
}
