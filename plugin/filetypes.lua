-- Setup custom file types

-- Map some file names not known by Neovim to a filetype
local filetype_by_filename = {
  [".env.example"] = "sh", -- Same as `.env`
  [".fdignore"] = "conf", -- auto-detected by nvim
  [".ideavimrc"] = "vim",
  [".ignore"] = "conf", -- auto-detected by nvim
  [".markdownlintrc"] = "json", -- or ini
  [".prettierignore"] = "conf", -- auto-detected by nvim
  [".prettierrc"] = "yaml", -- or json
  [".shellcheckrc"] = "conf", -- auto-detected by nvim
  [".stow-global-ignore"] = "conf", -- auto-detected by nvim
  [".stow-local-ignore"] = "conf", -- auto-detected by nvim
  [".vimiumrc"] = "vim",
  [".yamlfmt"] = "yaml",
  [".yamllint"] = "yaml",
  ["ignore"] = "conf", -- auto-detected by nvim
  ["ripgreprc"] = "conf", -- auto-detected by nvim
}
vim.filetype.add({ filename = filetype_by_filename })

-- Attribute to filenames in `filetype_by_filename` the nvim-web-devicons icon data corresponding to the filetype
local web_devicons = package.loaded["nvim-web-devicons"] -- Plugin scripts are loaded after start-up plugins
local supported_filenames = vim.tbl_keys(web_devicons.get_icons_by_filename()) -- Up-to-date list of supported filenames
local icon_data_by_filename = {}
for filename, filetype in pairs(filetype_by_filename) do
  if not vim.tbl_contains(supported_filenames, filename) then -- Don't override already supported filenames
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

-- Define filetypes of temporary buffers (typically plugins' ones)
local temporary_filetypes = {
  "", -- No buffer opened
  "dap-repl",
  "dapui_breakpoints",
  "dapui_console",
  "dapui_scopes",
  "dapui_watches",
  "NeogitStatus",
  "oil",
}
vim.g.temporary_filetypes = temporary_filetypes
