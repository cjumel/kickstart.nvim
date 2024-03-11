-- [[ Define additional filetype mappings

local filename_to_filetype = {
  [".markdownlintrc"] = "json",
}

vim.filetype.add({
  filename = filename_to_filetype,
})
