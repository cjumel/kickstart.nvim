return {
  name = "typst",
  condition = { callback = function(_) return vim.fn.executable("typst") == 1 end },
  generator = function(_, cb)
    cb({
      {
        name = "typst compile <file>",
        condition = { filetype = "typst" },
        builder = function(_)
          local path = vim.fn.expand("%:p:~:.") -- Current file path relative to cwd or HOME or absolute
          return {
            cmd = { "typst", "compile" },
            args = { path },
          }
        end,
      },
      {
        name = "typst watch <file>",
        condition = { filetype = "typst" },
        builder = function(_)
          local path = vim.fn.expand("%:p:~:.") -- Current file path relative to cwd or HOME or absolute
          return {
            cmd = { "typst", "watch" },
            args = { path },
          }
        end,
      },
    })
  end,
}
