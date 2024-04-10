-- nvim-web-devicons
--
-- A Lua for of vim-devicons, providing icons as well as colors for each icon.

return {
  "nvim-tree/nvim-web-devicons",
  lazy = true,
  opts = {
    override_by_filename = {
      [".env.example"] = { -- Values taken from nvim-web-devicons except for name
        icon = "",
        color = "#faf743",
        cterm_color = "227",
        name = "EnvExample",
      },
    },
  },
  config = function(_, opts)
    local web_devicons = require("nvim-web-devicons")

    web_devicons.setup(opts)

    -- Attribute existing icons & colors to custom file types
    -- This enables for instance Oil to use the right icons for the custom file types
    local filetypes = require("filetypes")
    local utils = require("utils")
    local icon_data_by_filename = {}
    for filename, filetype in pairs(filetypes.by_filename) do
      -- Don't override icons set in opts.override_by_filename
      if not utils.table.is_in_dict_keys(filename, opts.override_by_filename) then
        local icon, color, cterm_color = web_devicons.get_icon_colors(filetype)
        icon_data_by_filename[filename] = {
          icon = icon,
          color = color,
          cterm_color = cterm_color,
          name = filetype,
        }
      end
    end
    web_devicons.set_icon(icon_data_by_filename)
  end,
}
