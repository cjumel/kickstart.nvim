local custom_conds = require("plugins.core.luasnip.conditions")
local ls = require("luasnip")

local c = ls.choice_node
local s = ls.snippet
local t = ls.text_node

return {
  -- File extensions
  s({ trig = ".json", show_condition = custom_conds.non_empty_line_end }, { t(".json") }),
  s({ trig = ".lua", show_condition = custom_conds.non_empty_line_end }, { t(".lua") }),
  s({ trig = ".md", show_condition = custom_conds.non_empty_line_end }, { t(".md") }),
  s({ trig = ".py", show_condition = custom_conds.non_empty_line_end }, { t(".py") }),
  s({ trig = ".sh", show_condition = custom_conds.non_empty_line_end }, { t(".sh") }),
  s({ trig = ".toml", show_condition = custom_conds.non_empty_line_end }, { t(".toml") }),
  s({ trig = ".txt", show_condition = custom_conds.non_empty_line_end }, { t(".txt") }),
  s({ trig = ".typ", show_condition = custom_conds.non_empty_line_end }, { t(".typ") }),
  s({ trig = ".yaml", show_condition = custom_conds.non_empty_line_end }, { c(1, { t(".yaml"), t(".yml") }) }),
  s({ trig = ".zsh", show_condition = custom_conds.non_empty_line_end }, { t(".zsh") }),

  -- Preset files
  -- Lua
  s({ trig = "init.lua", show_condition = custom_conds.empty_line }, { t("init.lua") }),
  s({ trig = "temp.lua", show_condition = custom_conds.empty_line }, { t("temp.lua") }),
  -- Markdown
  s({ trig = "NOTES.md", show_condition = custom_conds.empty_line }, { t("NOTES.md") }),
  s({ trig = "README.md", show_condition = custom_conds.empty_line }, { t("README.md") }),
  s({ trig = "TODO.md", show_condition = custom_conds.empty_line }, { t("TODO.md") }),
  -- Python
  s({ trig = "__init__.py", show_condition = custom_conds.empty_line }, { t("__init__.py") }),
  s({ trig = "temp.py", show_condition = custom_conds.empty_line }, { t("temp.py") }),
  -- Other
  s({ trig = ".gitignore", show_condition = custom_conds.empty_line }, { t(".gitignore") }),
}
