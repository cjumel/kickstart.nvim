local ls = require("luasnip")

local s = ls.snippet
local t = ls.text_node

return {
  -- Lua
  s("init.lua", { t("init.lua") }),
  s("scratch.lua", { t("scratch.lua") }),
  -- Python
  s("__init__.py", { t("__init__.py") }),
  s("scratch.py", { t("scratch.py") }),
  -- Norg
  s("notes.norg", { t("notes.norg") }),
  s("todo.norg", { t("todo.norg") }),
}
