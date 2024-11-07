return {
  name = "typst",
  condition = { callback = function(_) return vim.fn.executable("typst") == 1 end },
  generator = function(_, cb)
    cb({
      {
        name = "typst compile <file>",
        condition = { filetype = "typst" },
        builder = function(_)
          return {
            cmd = { "typst", "compile" },
            args = { vim.fn.expand("%:p:~:.") },
          }
        end,
      },
      {
        name = "typst watch <file>",
        condition = { filetype = "typst" },
        builder = function(_)
          return {
            cmd = { "typst", "watch" },
            args = { vim.fn.expand("%:p:~:.") },
          }
        end,
      },
    })
  end,
}
