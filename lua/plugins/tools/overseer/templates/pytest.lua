local base_template = {
  params = {
    args = {
      type = "list",
      delimiter = ", ", -- Some arguments can have spaces (e.g. in "-m 'not slow'"), we need a comma for them to work
      optional = true,
      default = {},
    },
  },
}

--- Output the name of the current Python test function using Treesitter, or nil if there is none or this is not a
--- Python file or a test function.
---@return string|nil
local function get_python_test_function_name()
  if not vim.fn.expand("%:p"):match("_test.py$") then -- Not a Python test file
    return nil
  end

  local node = vim.treesitter.get_node() -- Get the node under the cursor
  while node ~= nil do
    if node:type() == "function_definition" then -- Node is a function definition
      local name_nodes = node:field("name")
      assert(#name_nodes == 1, "Expected exactly one name node")
      local name_node = name_nodes[1] -- Get the name node

      local function_name = vim.treesitter.get_node_text(name_node, vim.api.nvim_get_current_buf())
      if function_name:match("^test_") then -- This is a test function
        return function_name
      end
    end
    node = node:parent()
  end

  return nil
end

return {
  name = "pytest",
  condition = { callback = function(_) return vim.fn.executable("pytest") == 1 end },
  generator = function(_, cb)
    local overseer = require("overseer")

    local function_name = get_python_test_function_name()

    cb({
      overseer.wrap_template(base_template, {
        name = "pytest",
        builder = function(params)
          return {
            cmd = "pytest",
            args = params.args,
          }
        end,
      }, nil),
      overseer.wrap_template(base_template, {
        name = "pytest <file>",
        condition = { callback = function(_) return vim.fn.expand("%:p"):match("_test.py$") end },
        builder = function(params)
          local path = vim.fn.expand("%:p:~:.") -- Current file path relative to cwd or HOME or absolute
          return {
            cmd = "pytest",
            args = vim.list_extend(params.args or {}, { path }),
          }
        end,
      }, nil),
      overseer.wrap_template(base_template, {
        name = "pytest <dir>",
        condition = {
          callback = function(_)
            return vim.bo.filetype == "oil"
              and vim.fn.fnamemodify(package.loaded.oil.get_current_dir(), ":p"):match("/tests/")
          end,
        },
        builder = function(params)
          local path = package.loaded.oil.get_current_dir()
          path = vim.fn.fnamemodify(path, ":p:~:.") -- Make path relative to cwd or HOME or absolute
          return {
            cmd = "pytest",
            args = vim.list_extend(params.args or {}, { path }),
          }
        end,
      }, nil),
      overseer.wrap_template(base_template, {
        name = "pytest <function>",
        condition = { callback = function(_) return function_name ~= nil end },
        builder = function(params)
          local path = vim.fn.expand("%:p:~:.") -- Current file path relative to cwd or HOME or absolute
          return {
            cmd = "pytest",
            args = vim.list_extend(params.args or {}, { path .. "::" .. function_name }),
          }
        end,
      }, nil),
    })
  end,
}
