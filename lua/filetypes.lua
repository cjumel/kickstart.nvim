-- [[ Define additional filetype mappings

local filetypes_by_filename = {
  [".ideavimrc"] = "vim",
  [".fdignore"] = "conf", -- auto-detected by nvim
  [".markdownlintrc"] = "json", -- or ini
  [".prettierignore"] = "conf", -- auto-detected by nvim
  [".prettierrc"] = "yaml", -- or json
  [".shellcheckrc"] = "conf", -- auto-detected by nvim
  [".stow-global-ignore"] = "conf", -- auto-detected by nvim
  [".stow-local-ignore"] = "conf", -- auto-detected by nvim
  [".vimiumrc"] = "vim",
  [".yamlfmt"] = "yaml",
  [".yamllint"] = "yaml",
}

return {
  by_filename = filetypes_by_filename,
}
