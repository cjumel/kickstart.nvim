local custom_conditions = require("plugins.core.luasnip.conditions")
local ls = require("luasnip")
local ls_show_conditions = require("luasnip.extras.conditions.show")

local c = ls.choice_node
local s = ls.snippet
local t = ls.text_node

local extension_condition = -custom_conditions.line_begin * ls_show_conditions.line_end
local preset_file_condition = custom_conditions.line_begin * ls_show_conditions.line_end

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
  s({ trig = "init.lua", show_condition = preset_file_condition }, { t("init.lua") }),
  s({ trig = "temp.lua", show_condition = preset_file_condition }, { t("temp.lua") }),
  -- Markdown
  s({ trig = "NOTES.md", show_condition = preset_file_condition }, { t("NOTES.md") }),
  s({ trig = "README.md", show_condition = preset_file_condition }, { t("README.md") }),
  s({ trig = "TODO.md", show_condition = preset_file_condition }, { t("TODO.md") }),
  -- Python
  s({ trig = "__init__.py", show_condition = preset_file_condition }, { t("__init__.py") }),
  s({ trig = "temp.py", show_condition = preset_file_condition }, { t("temp.py") }),
}
