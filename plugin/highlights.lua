-- Simplify Snacks.nvim picker highlights
vim.api.nvim_set_hl(0, "SnacksPickerDir", { link = "SnacksPickerFile" })
vim.api.nvim_set_hl(0, "SnacksPickerDirectory", { link = "SnacksPickerFile" })

-- Use same highlight groups for hidden and non-hidden items in Oil.nvim buffers
vim.api.nvim_set_hl(0, "OilDirHidden", { link = "OilDir" })
vim.api.nvim_set_hl(0, "OilSocketHidden", { link = "OilSocket" })
vim.api.nvim_set_hl(0, "OilLinkHidden", { link = "OilLink" })
vim.api.nvim_set_hl(0, "OilOrphanLinkHidden", { link = "OilOrphanLink" })
vim.api.nvim_set_hl(0, "OilLinkTargetHidden", { link = "OilLinkTarget" })
vim.api.nvim_set_hl(0, "OilOrphanLinkTargetHidden", { link = "OilOrphanLinkTarget" })
vim.api.nvim_set_hl(0, "OilFileHidden", { link = "OilFile" })
