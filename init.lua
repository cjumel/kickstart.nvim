-- Set <space> as the leader key
--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- [[ Install `lazy.nvim` plugin manager ]]
require("lazy-bootstrap")

-- [[ Configure plugins ]]
require("lazy-plugins")

-- [[ Setting options ]]
require("options")

-- [[ Basic Keymaps ]]
require("keymaps")

-- vim: ts=2 sts=2 sw=2 et
