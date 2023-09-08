-- Nvim-treesitter
--
-- Neovim implementation of treesitter, implementing several features (code highlighting,
-- navigation or edition), based on a language parser. Parsers exist for many languages.

return {
  'nvim-treesitter/nvim-treesitter',
  dependencies = {
    'nvim-treesitter/nvim-treesitter-textobjects',
  },
  build = ':TSUpdate',
}
