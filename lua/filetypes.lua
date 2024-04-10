-- [[ Define additional filetype mappings

local filetypes_by_filename = {
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

return {
  by_filename = filetypes_by_filename,
}
