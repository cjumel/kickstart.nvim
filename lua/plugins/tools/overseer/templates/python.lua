return {
  name = "python",
  condition = { callback = function(_) return vim.fn.executable("python") == 1 end },
  generator = function(_, cb)
    cb({
      {
        name = "python <file>",
        condition = { filetype = "python" },
        builder = function(_)
          return {
            cmd = "python",
            args = { vim.fn.expand("%:p:~:.") },
          }
        end,
      },
    })
  end,
}
