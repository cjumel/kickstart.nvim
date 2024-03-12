-- [[ Define additional filetype mappings

local filetypes_by_filename = {
  [".ideavimrc"] = "vim",
  [".markdownlintrc"] = "json",
  [".vimiumrc"] = "vim",
  [".yamlfmt"] = "yaml",
}

return {
  by_filename = filetypes_by_filename,
}
