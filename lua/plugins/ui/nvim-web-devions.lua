-- nvim-web-devicons
--
-- A Lua for of vim-devicons, providing icons as well as colors for each icon.

return {
  "nvim-tree/nvim-web-devicons",
  lazy = true,
  opts = function()
    -- Fetch the highlight group for Directory, which is the one used by Oil for directories
    local hl_id = vim.api.nvim_get_hl_id_by_name("Directory")
    local hl = vim.api.nvim_get_hl(0, { id = hl_id })
    -- Convert the highlight group's foreground color to a hex color
    local color = "#" .. string.format("%06x", hl.fg)

    return {
      override_by_filename = {
        -- Fix Telescope not showing icons for directories
        [""] = { -- Telescope uses get_icon with "" as argument for directories
          icon = "",
          color = color,
          name = "Directory",
        },
      },
    }
  end,
  config = function(_, opts)
    local web_devicons = require("nvim-web-devicons")

    web_devicons.setup(opts)

    -- Attribute existing icons & colors to custom file types
    local filetypes = require("filetypes")
    local icon_data_by_filename = {}
    for filename, filetype in pairs(filetypes.by_filename) do
      local icon, color, cterm_color = web_devicons.get_icon_colors(filetype)
      icon_data_by_filename[filename] = {
        icon = icon,
        color = color,
        cterm_color = cterm_color,
        name = filetype,
      }
    end
    web_devicons.set_icon(icon_data_by_filename)
  end,
}
