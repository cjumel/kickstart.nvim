-- Configure diagnostics

-- Make diagnostic signs in sign column the same as in Lualine
local signs = { -- values are taken from lualine/components/diagnostics/config.lua
  Error = "󰅚 ", -- x000f015a
  Warn = "󰀪 ", -- x000f002a
  Hint = "󰌶 ", -- x000f0336
  Info = "󰋽 ", -- x000f02fd
}
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

vim.diagnostic.config({
  float = { border = "rounded" }, -- Border of the "show diagnostic" popup
  severity_sort = true, -- Display symbol for the most severe diagnostic in sign column
})
