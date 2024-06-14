return {
  name = "python",
  condition = { callback = function(_) return vim.fn.executable("python") == 1 end },
  generator = function(_, cb)
    cb({
      {
        name = "python <file>",
        condition = { filetype = "python" },
        builder = function(_)
          local path = vim.fn.expand("%:p:~:.") -- Current file path relative to cwd or HOME or absolute
          return {
            cmd = "python",
            args = { path },
          }
        end,
      },
    })
  end,
}
