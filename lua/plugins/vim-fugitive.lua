-- fugitive.vim
--
-- Fugitive provides a few git-related features, which make it and gitsigns perfect for a complete
-- git integration.

-- TODO: add keymap to git commit

return {
  "tpope/vim-fugitive",
  keys = {
    {
      "<leader>gs",
      "<cmd> botright Git <CR>",
      desc = "[G]it [S]tatus",
    },
  },
  config = function()
    -- Change keymaps in fugitive buffers
    local group = vim.api.nvim_create_augroup("Fugitive", { clear = false })
    local pattern = { "fugitive", "fugitiveblame" }

    -- Quit
    vim.api.nvim_create_autocmd(
      "FileType",
      { command = "nmap <buffer> q gq", group = group, pattern = pattern }
    )

    -- Navigate hunks
    vim.api.nvim_create_autocmd(
      "FileType",
      { command = "nmap <buffer> <C-p> (", group = group, pattern = pattern }
    )
    vim.api.nvim_create_autocmd(
      "FileType",
      { command = "nmap <buffer> <C-n> )", group = group, pattern = pattern }
    )

    -- Open files in split windows
    vim.api.nvim_create_autocmd(
      "FileType",
      { command = "nmap <buffer> <C-v> gO", group = group, pattern = pattern }
    )
    vim.api.nvim_create_autocmd(
      "FileType",
      { command = "nmap <buffer> <C-x> o", group = group, pattern = pattern }
    )
  end,
}
