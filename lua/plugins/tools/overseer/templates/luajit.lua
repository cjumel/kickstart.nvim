return {
  name = "luajit",
  condition = { callback = function(_) return vim.fn.executable("luajit") == 1 end },
  generator = function(_, cb)
    cb({
      {
        name = "luajit <file>",
        condition = { filetype = "lua" },
        builder = function(_)
          return {
            cmd = "luajit",
            args = { vim.fn.expand("%:p:~:.") },
          }
        end,
      },
    })
  end,
}
