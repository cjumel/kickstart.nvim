return {
  name = "luajit",
  builder = function(params)
    return {
      cmd = { "luajit" },
      args = vim.list_extend({ vim.fn.expand("%:p:.") }, params.args),
    }
  end,
  tags = { "RUN" },
  params = {
    args = {
      type = "list",
      delimiter = " ",
      optional = true,
      default = {},
    },
  },
  condition = {
    filetype = "lua",
    callback = function(_) return vim.fn.executable("luajit") == 1 end,
  },
}
