-- Use same highlights for paths and file/directory names in Snacks.nvim pickers
vim.api.nvim_set_hl(0, "SnacksPickerDir", { link = "SnacksPickerFile" })
vim.api.nvim_set_hl(0, "SnacksPickerDirectory", { link = "SnacksPickerFile" })

-- Use same highlights for hidden and regular files/directories in Oil.nvim buffers
vim.api.nvim_set_hl(0, "OilDirHidden", { link = "OilDir" })
vim.api.nvim_set_hl(0, "OilSocketHidden", { link = "OilSocket" })
vim.api.nvim_set_hl(0, "OilLinkHidden", { link = "OilLink" })
vim.api.nvim_set_hl(0, "OilOrphanLinkHidden", { link = "OilOrphanLink" })
vim.api.nvim_set_hl(0, "OilLinkTargetHidden", { link = "OilLinkTarget" })
vim.api.nvim_set_hl(0, "OilOrphanLinkTargetHidden", { link = "OilOrphanLinkTarget" })
vim.api.nvim_set_hl(0, "OilFileHidden", { link = "OilFile" })
