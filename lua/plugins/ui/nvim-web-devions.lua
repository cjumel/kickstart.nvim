-- nvim-web-devicons
--
-- A Lua for of vim-devicons, providing icons as well as colors for each icon.

return {
  "nvim-tree/nvim-web-devicons",
  lazy = true,
  opts = {},
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
