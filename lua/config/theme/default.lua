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
        {
          function()
            local harpoon = package.loaded.harpoon
            if harpoon == nil then
              return ""
            end
            local path
            if vim.bo.buftype == "" then
              path = vim.fn.expand("%:p")
            elseif vim.bo.filetype == "oil" then
              path = "oil://" .. vim.fn.fnamemodify(require("oil").get_current_dir() --[[@as string]], ":p")
            else
              return ""
            end
            local s = ""
            for index = 1, harpoon:list():length() do
              local harpoon_item = harpoon:list():get(index)
              if harpoon_item ~= nil then
                if path == vim.fn.fnamemodify(harpoon_item.value, ":p") then
                  s = s .. "[" .. index .. "]"
                else
                  s = s .. " " .. index .. " "
                end
              end
            end
            return s ~= "" and "󰀱 " .. s or ""
          end,
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
