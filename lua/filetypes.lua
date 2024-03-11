-- [[ Define additional filetype mappings

local filename_to_filetype = {
  [".ideavimrc"] = "vim",
  [".markdownlintrc"] = "json",
  [".vimiumrc"] = "vim",
  [".yamlfmt"] = "yaml",
}

vim.filetype.add({
  filename = filename_to_filetype,
})
