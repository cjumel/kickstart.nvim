local ls = require("luasnip")

local i = ls.insert_node
local s = ls.snippet
local t = ls.text_node

return {
  s("alias", { t("alias "), i(1, "name"), t("='"), i(2, "command"), t("'") }),
  s("function", { t("function "), i(1, "name"), t("("), i(2), t("){ "), i(3), t(" }") }),
}
