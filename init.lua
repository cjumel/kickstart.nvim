-- Set <space> as the leader key
-- Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- [[ Install `lazy.nvim` plugin manager & configure plugins ]]
require("lazy-plugins")

-- vim: ts=2 sts=2 sw=2 et
