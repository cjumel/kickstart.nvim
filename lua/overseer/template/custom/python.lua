return {
  name = "python",
  condition = { callback = function(_) return vim.fn.executable("python") == 1 end },
  generator = function(_, cb)
    cb({
      {
        name = "python <file>",
        tags = { "RUN" },
        priority = 1,
        condition = { filetype = "python" },
        builder = function()
          return {
            cmd = "python",
            args = { vim.fn.expand("%:p:.") },
          }
        end,
      },
      {
        name = "python -m <module>",
        tags = { "RUN" },
        priority = 2,
        condition = { filetype = "python" },
        builder = function()
          local python_utils = require("config.lang_utils.python")
          return {
            cmd = "python",
            args = { "-m", python_utils.get_module() },
          }
        end,
      },
    })
  end,
}
