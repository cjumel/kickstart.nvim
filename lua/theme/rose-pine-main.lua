local extensions = require("plugins.ui.lualine.extensions")
local modules = require("plugins.ui.lualine.modules")
local sections = require("plugins.ui.lualine.sections")

local M = {}

M.rose_pine_enabled = true
M.rose_pine_opts = {
  variant = "main", -- auto, main, moon, or dawn
}

local custom_sections = vim.tbl_deep_extend("force", sections.empty, {
  lualine_c = {
    { "filename", path = 1 }, -- Relative file path
    "diff",
    "diagnostics",
  },
  lualine_x = { modules.macro, modules.harpoon, "location", "progress" },
})
M.lualine_opts = {
  options = {
    icons_enabled = false,
  },
  sections = custom_sections,
  extensions = extensions.build_extensions(custom_sections),
}
M.lualine_config = function(_, opts)
  require("lualine").setup(opts)

  -- HACK: prevent Lualine to show insert mode after a Telescope insert-mode search when `vim.opt.showmode = true`
  --  This fixes an issue which might be related to https://github.com/nvim-telescope/telescope.nvim/issues/2995, and
  --    the fix was taken from https://github.com/nvim-telescope/telescope.nvim/issues/2766. This can be removed once
  --    the issue is not observed anymore.
  --  To reproduce the issue:
  --    - open Neovim with `vim.opt.showmode = true` (default value)
  --    - trigger the LSP progress computation and wait for it to be finished as it prevents the issue from appearing
  --    - open a file with Telescope in insert mode
  --    - the Lualine should show the insert mode indicator (while not actually being in insert mode)
  vim.api.nvim_create_autocmd("WinLeave", {
    callback = function()
      if vim.bo.ft == "TelescopePrompt" and vim.fn.mode() == "i" then
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes([[<C-\><C-n>]], true, false, true), "i", false)
      end
    end,
  })
end

return M
