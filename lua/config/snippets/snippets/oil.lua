local conds = require("config.snippets.conditions")
local ls = require("luasnip")
local ls_conds = require("luasnip.extras.conditions")

local d = ls.dynamic_node
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node

---@param extension string
---@param config_files table|nil
---@return table
local function make_filetype_condition(extension, config_files)
  config_files = config_files or {}
  local function matching_function(name, _)
    if name == ".nvim.lua" then
      return false
    end
    if name:match(".*%." .. extension .. "$") then
      return true
    end
    return vim.tbl_contains(config_files, name)
  end
  return ls_conds.make_condition(function()
    local matches = vim.fs.find(matching_function, {
      type = "file",
      path = require("oil").get_current_dir(),
      upward = true,
      stop = vim.fn.getcwd(),
    })
    return not vim.tbl_isempty(matches)
  end)
end

---@param filename string
---@return table
local function make_filename_condition(filename)
  return ls_conds.make_condition(function()
    local oil = require("oil")
    local dir_path = oil.get_current_dir()
    if dir_path == nil then
      return false
    end
    return vim.fn.filereadable(dir_path .. filename) == 0
  end)
end

---@param base_name string
---@param extension string
---@return function
local function make_dynamic_file_index_node(base_name, extension)
  return function(_)
    local oil = require("oil")
    local dir_path = oil.get_current_dir()
    if dir_path == nil then
      return sn(nil, {})
    end
    if vim.fn.filereadable(dir_path .. base_name .. extension) == 0 then
      return sn(nil, {})
    end
    for i = 1, 99 do
      local suffix = "_" .. tostring(i)
      if vim.fn.filereadable(dir_path .. base_name .. suffix .. extension) == 0 then
        return sn(nil, { t(suffix) })
      end
    end
    return sn(nil, {})
  end
end

---@param base_name string
---@param extension string
---@return function
local function make_dynamic_file_date_node(base_name, extension)
  return function(_)
    local oil = require("oil")
    local dir_path = oil.get_current_dir()
    if dir_path == nil then
      return sn(nil, {})
    end
    local date = os.date("%Y-%m-%d")
    local suffix = "_" .. date -- Format suitable for alphanumeric order
    if vim.fn.filereadable(dir_path .. base_name .. suffix .. extension) == 0 then
      return sn(nil, { t(suffix) })
    end
    for i = 1, 99 do
      suffix = "_" .. date .. "_" .. tostring(i)
      if vim.fn.filereadable(dir_path .. base_name .. suffix .. extension) == 0 then
        return sn(nil, { t(suffix) })
      end
    end
    return sn(nil, {})
  end
end

-- When typing a trigger with a "." prefix, the "." is not part of the trigger, but it is replaced by the snippet.
-- Consequently, to enforce the line begin condition, we actually need a prefix condition instead, and to enforce the
-- non-line-begin condition, we also need a non-prefix condition.
local dot_prefix_condition = conds.make_prefix_condition(".")

-- Let's try to keep the config files list minimal without any loss in coverage
local lua_config_files = { "stylua.toml", ".stylua.toml" }
local python_config_files = { "pyproject.toml", ".ruff.toml", "setup.py", "requirements.txt" }
local rust_config_files = { "Cargo.toml" }

return {
  s({
    trig = ".json",
    show_condition = -dot_prefix_condition * -conds.line_begin * conds.line_end * make_filetype_condition("json"),
  }, { t(".json") }),

  s({
    trig = ".lua",
    show_condition = -dot_prefix_condition * -conds.line_begin * conds.line_end * make_filetype_condition(
      "lua",
      lua_config_files
    ),
  }, { t(".lua") }),
  s({
    trig = ".nvim.lua",
    show_condition = dot_prefix_condition * conds.line_end * make_filename_condition(".nvim.lua"),
  }, { t(".nvim.lua") }),
  s({
    trig = "init.lua",
    show_condition = conds.line_begin
      * conds.line_end
      * make_filetype_condition("lua", lua_config_files)
      * make_filename_condition("init.lua"),
  }, { t("init.lua") }),
  s({
    trig = "temp.lua",
    show_condition = conds.line_begin * conds.line_end * make_filetype_condition("lua", lua_config_files),
  }, { t("temp"), d(1, make_dynamic_file_index_node("temp", ".lua")), t(".lua") }),

  s({
    trig = ".md",
    show_condition = -dot_prefix_condition * -conds.line_begin * conds.line_end,
  }, { t(".md") }),
  s({
    trig = "notes-<date>.md",
    show_condition = conds.line_begin * conds.line_end,
  }, { t("notes"), d(1, make_dynamic_file_date_node("notes", ".md")), t(".md") }),
  s({
    trig = "README.md",
    show_condition = conds.line_begin * conds.line_end * make_filename_condition("README.md"),
  }, { t("README.md") }),
  s({
    trig = "TODO.md",
    show_condition = conds.line_begin * conds.line_end * make_filename_condition("TODO.md"),
  }, { t("TODO.md") }),

  s({
    trig = ".py",
    show_condition = -dot_prefix_condition * -conds.line_begin * conds.line_end * make_filetype_condition(
      "py",
      python_config_files
    ),
  }, { t(".py") }),
  s({
    trig = "__init__.py",
    show_condition = conds.make_prefix_condition("_") -- The snippet is triggered after the first "_"
      * conds.line_end
      * make_filetype_condition("py", python_config_files)
      * make_filename_condition("__init__.py"),
  }, { t("__init__.py") }),
  s({
    trig = "temp.py",
    show_condition = conds.line_begin * conds.line_end * make_filetype_condition("py", python_config_files),
  }, { t("temp"), d(1, make_dynamic_file_index_node("temp", ".py")), t(".py") }),

  s({
    trig = ".rs",
    show_condition = -dot_prefix_condition * -conds.line_begin * conds.line_end * make_filetype_condition(
      "rs",
      rust_config_files
    ),
  }, { t(".rs") }),
  s({
    trig = "temp.rs",
    show_condition = conds.line_begin * conds.line_end * make_filetype_condition("rs", rust_config_files),
  }, { t("temp"), d(1, make_dynamic_file_index_node("temp", ".rs")), t(".rs") }),

  s({
    trig = ".sh",
    show_condition = -dot_prefix_condition * -conds.line_begin * conds.line_end * make_filetype_condition("sh"),
  }, { t(".sh") }),

  s({
    trig = ".toml",
    show_condition = -dot_prefix_condition * -conds.line_begin * conds.line_end * make_filetype_condition("toml"),
  }, { t(".toml") }),

  s({
    trig = ".txt",
    show_condition = -dot_prefix_condition * -conds.line_begin * conds.line_end * make_filetype_condition("txt"),
  }, { t(".txt") }),

  s({
    trig = ".typ",
    show_condition = -dot_prefix_condition * -conds.line_begin * conds.line_end * make_filetype_condition("typ"),
  }, { t(".typ") }),

  s({
    trig = ".yaml",
    show_condition = -dot_prefix_condition * -conds.line_begin * conds.line_end * make_filetype_condition("yaml"),
  }, { t(".yaml") }),
  s({
    trig = ".yml",
    show_condition = -dot_prefix_condition * -conds.line_begin * conds.line_end * make_filetype_condition("yml"),
  }, { t(".yml") }),

  s({
    trig = ".zsh",
    show_condition = -dot_prefix_condition * -conds.line_begin * conds.line_end * make_filetype_condition("zsh"),
  }, { t(".zsh") }),
}
