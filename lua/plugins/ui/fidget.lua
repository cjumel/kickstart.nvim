-- Fidget
--
-- Extensible UI for Neovim notifications and LSP progress messages. Used as a fallback of Noice
-- to provide LSP status updates.

-- Handle the case the theme file is missing
local ok, theme = pcall(require, "theme")
if not ok then
  theme = {}
end

-- By default we want to enable Noice but we can't use `theme.noice_enabled or true` (always true)
local noice_enabled = true
if theme.noice_enabled == false then
  noice_enabled = false
end

return {
  "j-hui/fidget.nvim",
  -- If plugin is not enabled, just make it lazy to avoid changing the lazy lock file
  lazy = noice_enabled,
  opts = {},
}
