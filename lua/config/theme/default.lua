local M = {}

M.options_callback = function()
  vim.opt.showmode = true -- Show mode in status line

  -- Remove Neovim background colors to enable transparency
  vim.cmd.highlight("Normal guibg=none")
  vim.cmd.highlight("NonText guibg=none")
  vim.cmd.highlight("Normal ctermbg=none")
  vim.cmd.highlight("NonText ctermbg=none")
end

M.get_lualine_opts = function(_)
  return {
    options = {
      icons_enabled = false,
      theme = { -- Remove Lualine colors (colors associated with the default theme are not super readable)
        inactive = { c = {} },
        visual = { c = {} },
        replace = { c = {} },
        normal = { c = {} },
        insert = { c = {} },
        command = { c = {} },
      },
    },
    sections = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = {
        { "filename", path = 1 }, -- Relative file path
        "diff",
        "diagnostics",
      },
      lualine_x = {
        { -- Display macro recording status when there is one
          function()
            local noice = package.loaded.noice
            if noice ~= nil then
              return noice.api.statusline.mode.get()
            end
          end,
          cond = function()
            local noice = package.loaded.noice
            if noice ~= nil then
              return noice.api.statusline.mode.has()
            end
          end,
          color = { fg = "#ff9e64" }, -- Orange
        },
        {
          "searchcount",
          color = { fg = "#ff9e64" }, -- Orange
        },
        "filetype",
        "location",
        "progress",
      },
      lualine_y = {},
      lualine_z = {},
    },
  }
end

return M
