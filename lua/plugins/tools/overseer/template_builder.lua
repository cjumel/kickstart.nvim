-- Define functions to quickly build Overseer templates for generic use cases.

local utils = require("utils")

local M = {}

local function get_cmd_name(cmd)
  if type(cmd) == "table" then
    return table.concat(cmd, " ")
  else
    return cmd
  end
end

local function get_condition(opts)
  return {
    callback = function(search)
      if opts.filetype == "all" then -- Custom case to handle the case of filetypes corresponding to real files
        if utils.buffer.is_temporary() then
          return false
        end
      elseif type(opts.filetype) == "string" then
        if vim.bo.filetype ~= opts.filetype then
          return false
        end
      elseif type(opts.filetype) == "table" then
        if not vim.tbl_contains(vim.opts.filetype, opts.filetype) then
          return false
        end
      end

      if opts.condition_callback ~= nil then
        return opts.condition_callback(search)
      end

      return true
    end,
  }
end

local function get_params(opts)
  local params = {}
  if opts.has_args then
    params.args = {
      type = "list",
      subtype = { type = "string" },
      optional = true,
    }

    if opts.default_args ~= nil then
      params.args.default = opts.default_args
    end
  end

  return params
end

--- Build an Overseer template for a simple command.
---@param cmd string|string[] The command to run.
---@param opts table|nil The options for the template. Supported options are:
---   - condition_callback: function A callback to determine if the template should be shown.
---   - has_args: boolean Whether the command supports additional arguments or not.
---   - default_args: string|string[] The default arguments to use.
---@return table[] _ The resulting Overseer template.
function M.cmd(cmd, opts)
  opts = vim.deepcopy(opts or {}) -- Prevent issues when sharing `opts` between several builder calls
  opts.filetype = nil -- Overwrite the `filetype` option

  return {
    name = get_cmd_name(cmd),
    condition = get_condition(opts),
    params = get_params(opts),
    builder = function(params)
      return {
        cmd = cmd,
        args = params.args,
      }
    end,
  }
end

--- Build an Overseer template for a simple command to run on the current file.
---@param cmd string|string[] The command to run.
---@param opts table|nil The options for the template. Supported options are:
---   - filetype: string|string[] The filetype(s) for which to show the template.
---   - condition_callback: function A callback to determine if the template should be shown.
---   - has_args: boolean Whether the command supports additional arguments or not.
---   - default_args: string|string[] The default arguments to use.
---@return table[] _ The resulting Overseer template.
function M.cmd_file(cmd, opts)
  opts = vim.deepcopy(opts or {}) -- Prevent issues when sharing `opts` between several builder calls

  return {
    name = get_cmd_name(cmd) .. " <file>",
    condition = get_condition(opts),
    params = get_params(opts),
    builder = function(params)
      local path = utils.path.get_current_file_path()
      if path == nil then
        vim.notify("No file found")
        return {}
      end

      return {
        cmd = cmd,
        args = vim.list_extend(params.args or {}, { path }),
      }
    end,
  }
end

--- Build an Overseer template for a simple command to run on the current Oil directory.
---@param cmd string|string[] The command to run.
---@param opts table|nil The options for the template. Supported options are:
---   - condition_callback: function A callback to determine if the template should be shown.
---   - has_args: boolean Whether the command supports additional arguments or not.
---   - default_args: string|string[] The default arguments to use.
---@return table[] _ The resulting Overseer template.
function M.cmd_dir(cmd, opts)
  opts = vim.deepcopy(opts or {}) -- Prevent issues when sharing `opts` between several builder calls
  opts.filetype = "oil" -- Overwrite the `filetype` option

  return {
    name = get_cmd_name(cmd) .. " <dir>",
    condition = get_condition(opts),
    params = get_params(opts),
    builder = function(params)
      local path = utils.path.get_current_oil_directory()
      if path == nil then
        vim.notify("No directory found")
        return {}
      end

      return {
        cmd = cmd,
        args = vim.list_extend(params.args or {}, { path }),
      }
    end,
  }
end

--- Build an Overseer template for a simple command to run on the current working directory.
---@param cmd string|string[] The command to run.
---@param opts table|nil The options for the template. Supported options are:
---   - condition_callback: function A callback to determine if the template should be shown.
---   - has_args: boolean Whether the command supports additional arguments or not.
---   - default_args: string|string[] The default arguments to use.
---@return table[] _ The resulting Overseer template.
function M.cmd_cwd(cmd, opts)
  opts = vim.deepcopy(opts or {}) -- Prevent issues when sharing `opts` between several builder calls
  opts.filetype = nil -- Overwrite the `filetype` option

  return {
    name = get_cmd_name(cmd) .. " <cwd>",
    condition = get_condition(opts),
    params = get_params(opts),
    builder = function(params)
      local path = utils.path.normalize(vim.fn.getcwd())
      if path == nil then
        vim.notify("No directory found")
        return {}
      end

      return {
        cmd = cmd,
        args = vim.list_extend(params.args or {}, { path }),
      }
    end,
  }
end

return M
