local custom_conditions = require("plugins.core.luasnip.conditions")
local ls = require("luasnip")
local ls_conditions = require("luasnip.extras.conditions")
local ls_conditions_show = require("luasnip.extras.conditions.show")
local utils = require("utils")

local c = ls.choice_node
local s = ls.snippet
local t = ls.text_node

local extension_condition = -custom_conditions.line_begin * ls_conditions_show.line_end
local preset_file_condition = custom_conditions.line_begin * ls_conditions_show.line_end

--- Check if the current Oil directory is in a Lua project, by checking in the current directory & its parents until
--- the Git root or the HOME directory is found whether a Lua file or a Stylua configuration file is present.
---@return boolean
local function lua_project_callback()
  local lua_related_files = vim.fs.find(
    function(name, _) return name:match(".*%.lua$") or vim.tbl_contains({ ".stylua.toml", "stylua.toml" }, name) end,
    {
      type = "file",
      path = package.loaded.oil.get_current_dir(),
      upward = true, -- Search in the current directory and its parents
      stop = utils.buffer.get_git_root() or vim.env.HOME, -- Stop searching at the Git root or the HOME directory
    }
  )
  return not vim.tbl_isempty(lua_related_files)
end

--- Check if the current Oil directory is in a Python project, by checking in the current directory & its parents until
--- the Git root or the HOME directory is found whether a Python file or a `pyproject.toml` file is present.
---@return boolean
local function python_project_callback()
  local lua_related_files = vim.fs.find(
    function(name, _) return name:match(".*%.py$") or vim.tbl_contains({ "pyproject.toml" }, name) end,
    {
      type = "file",
      path = package.loaded.oil.get_current_dir(),
      upward = true, -- Search in the current directory and its parents
      stop = utils.buffer.get_git_root() or vim.env.HOME, -- Stop searching at the Git root or the HOME directory
    }
  )
  return not vim.tbl_isempty(lua_related_files)
end

local lua_project_condition = ls_conditions.make_condition(lua_project_callback)
local python_project_condition = ls_conditions.make_condition(python_project_callback)

return {
  -- File extensions
  s({ trig = ".json", show_condition = extension_condition }, { t(".json") }),
  s({ trig = ".lua", show_condition = extension_condition }, { t(".lua") }),
  s({ trig = ".md", show_condition = extension_condition }, { t(".md") }),
  s({ trig = ".py", show_condition = extension_condition }, { t(".py") }),
  s({ trig = ".sh", show_condition = extension_condition }, { t(".sh") }),
  s({ trig = ".toml", show_condition = extension_condition }, { t(".toml") }),
  s({ trig = ".txt", show_condition = extension_condition }, { t(".toml") }),
  s({ trig = ".yaml", show_condition = extension_condition }, { c(1, { t(".yaml"), t(".yml") }) }),
  s({ trig = ".zsh", show_condition = extension_condition }, { t(".zsh") }),

  -- Preset files
  -- Lua
  s({ trig = "init.lua", show_condition = preset_file_condition * lua_project_condition }, { t("init.lua") }),
  s({ trig = "temp.lua", show_condition = preset_file_condition * lua_project_condition }, { t("temp.lua") }),
  -- Markdown
  s({ trig = "NOTES.md", show_condition = preset_file_condition }, { t("NOTES.md") }),
  s({ trig = "README.md", show_condition = preset_file_condition }, { t("README.md") }),
  s({ trig = "TODO.md", show_condition = preset_file_condition }, { t("TODO.md") }),
  -- Python
  s({ trig = "__init__.py", show_condition = preset_file_condition * python_project_condition }, { t("__init__.py") }),
  s({ trig = "temp.py", show_condition = preset_file_condition * python_project_condition }, { t("temp.py") }),
}
