-- sleuth.vim
--
-- Heuristically detect tabstop and shiftwidth based on the current file.

return {
  'tpope/vim-sleuth',
  lazy = false, -- This must not be lazy, otherwise it would break the indent line
}
