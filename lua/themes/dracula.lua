local M = {}

M.dracula_enabled = true

M.lualine_opts = {
  options = {
    theme = "dracula-nvim",
    component_separators = "|",
    section_separators = "",
    refresh = {
      statusline = 50, -- Decrease refresh rate to make modules more responsive (e.g. Harpoon's)
    },
  },
}

return M
