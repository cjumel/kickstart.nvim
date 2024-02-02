local ls = require("luasnip")

local s = ls.snippet
local t = ls.text_node

return {
  -- Scratch files
  s("scratch.lua", { t("scratch.lua") }),
  s("scratch.py", { t("scratch.py") }),
  -- Norg
  s("notes.norg", { t("notes.norg") }),
  s("todo.norg", { t("todo.norg") }),
}
