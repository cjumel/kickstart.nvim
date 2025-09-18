return {
  name = "python",
  builder = function(params)
    local mode
    if params.mode == "auto" then
      local absolute_file_path = vim.fn.expand("%:p")
      local absolute_cwd_path = vim.fn.fnamemodify(vim.fn.getcwd(), ":p")
      local file_is_in_cwd = string.sub(absolute_file_path, 1, #absolute_cwd_path) == absolute_cwd_path
      mode = file_is_in_cwd and "module" or "file"
    elseif vim.tbl_contains({ "module", "file" }, params.mode) then
      mode = params.mode
    else
      error("Invalid mode: " .. tostring(params.mode))
    end
    if mode == "module" then
      local python_utils = require("config.lang_utils.python")
      return {
        cmd = "python",
        args = vim.list_extend({ "-m", python_utils.get_module() }, params.args),
      }
    else
      return {
        cmd = "python",
        args = vim.list_extend({ vim.fn.expand("%:p:.") }, params.args),
      }
    end
  end,
  tags = { "RUN" },
  params = {
    mode = {
      type = "enum",
      choices = { "auto", "module", "file" },
      optional = true,
      default = "auto",
      desc = '-- "auto", "module", or "file"',
      order = 1,
    },
    args = {
      type = "list",
      delimiter = " ",
      optional = true,
      default = {},
      order = 2,
    },
  },
  condition = {
    filetype = "python",
    callback = function(_) return vim.fn.executable("python") == 1 end,
  },
}
