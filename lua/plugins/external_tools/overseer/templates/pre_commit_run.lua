return {
  name = "Run pre-commit on file",
  builder = function()
    return {
      cmd = { "pre-commit", "run", "--file", vim.fn.expand("%:p") },
    }
  end,
}
