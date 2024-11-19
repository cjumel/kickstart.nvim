--- Output the name of the current Python test function using Treesitter, or nil if none can be found.
---@return string|nil
local function get_python_test_function_name()
  if not vim.fn.expand("%:p"):match("_test.py$") then -- Not a Python test file
    return nil
  end

  local node = vim.treesitter.get_node() -- Get the Teesitter node under the cursor
  while node ~= nil do
    if node:type() == "function_definition" then
      local name_nodes = node:field("name")
      assert(#name_nodes == 1, "Expected exactly one name node")
      local name_node = name_nodes[1]

      local function_name = vim.treesitter.get_node_text(name_node, vim.api.nvim_get_current_buf())
      if function_name:match("^test_") then -- This is a test function
        return function_name
      end
    end
    node = node:parent()
  end

  return nil
end

local base_template = {
  params = {
    options = {
      desc = "Options or optional arguments",
      type = "list",
      delimiter = " ", -- Arguments with white spaces (e.g. in "-m 'not slow'") are not working here
      optional = true,
      default = {},
    },
  },
}

return {
  name = "pytest",
  condition = { callback = function(_) return vim.fn.executable("pytest") == 1 end },
  generator = function(_, cb)
    local overseer = require("overseer")

    local python_test_function_name = get_python_test_function_name()

    cb({
      overseer.wrap_template(base_template, {
        name = "pytest",
        tags = { "TEST" },
        builder = function(params)
          return {
            cmd = "pytest",
            args = params.options,
          }
        end,
      }),
      overseer.wrap_template(base_template, {
        name = "pytest <file>",
        tags = { "TEST" },
        condition = { callback = function(_) return vim.fn.expand("%:p"):match("_test.py$") end },
        builder = function(params)
          return {
            cmd = "pytest",
            args = vim.list_extend(params.options, { vim.fn.expand("%:p:~:.") }),
          }
        end,
      }),
      overseer.wrap_template(base_template, {
        name = "pytest <function>",
        tags = { "TEST" },
        condition = { callback = function(_) return python_test_function_name ~= nil end },
        builder = function(params)
          return {
            cmd = "pytest",
            args = vim.list_extend(params.options, { vim.fn.expand("%:p:~:.") .. "::" .. python_test_function_name }),
          }
        end,
      }),
    })
  end,
}
