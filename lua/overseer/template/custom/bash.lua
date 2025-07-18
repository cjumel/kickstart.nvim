return {
  name = "bash",
  condition = { callback = function(_) return vim.fn.executable("bash") == 1 end },
  generator = function(_, cb)
    cb({
      {
        name = "bash <file>",
        tags = { "RUN" },
        condition = { filetype = "sh" },
        builder = function(_)
          return {
            cmd = "bash",
            args = { vim.fn.expand("%:p:.") },
          }
        end,
      },
    })
  end,
}
