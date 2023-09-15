-- fugitive.vim
--
-- Fugitive provides a few git-related features, which make it and gitsigns perfect for a complete
-- git integration.

return {
  "tpope/vim-fugitive",
  cmd = { "Git" },
  init = function()
    vim.keymap.set("n", "<leader>gs", "<cmd> tab Git <CR>", { desc = "[G]it [S]tatus" })

    -- Change keymaps in fugitive buffers
    local group = vim.api.nvim_create_augroup("Fugitive", { clear = false })
    local pattern = { "fugitive", "fugitiveblame" }
    vim.api.nvim_create_autocmd(
      "FileType",
      { command = "nmap <buffer> q gq", group = group, pattern = pattern }
    )
    vim.api.nvim_create_autocmd(
      "FileType",
      { command = "nmap <buffer> <C-p> (", group = group, pattern = pattern }
    )
    vim.api.nvim_create_autocmd(
      "FileType",
      { command = "nmap <buffer> <C-n> )", group = group, pattern = pattern }
    )
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
