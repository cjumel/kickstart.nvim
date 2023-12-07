local ls = require("luasnip")

local c = ls.choice_node
local i = ls.insert_node
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node

local fmt = require("luasnip.extras.fmt").fmt

local expand_conds = require("luasnip.extras.conditions.expand")
local custom_conds = require("plugins.code.luasnip.utils.conds")

return {
  s(
    "import",
    fmt(
      [[
        import {}{}
      ]],
      {
        i(1, "module"),
        c(2, {
          t(""),
          sn(nil, { t(" as "), i(1, "name") }),
        }),
      }
    )
  ),
  s(
    "from",
    fmt(
      [[
        from {} import {}{}
      ]],
      {
        i(1, "module"),
        i(2, "var"),
        c(3, {
          t(""),
          sn(nil, { t(" as "), i(1, "name") }),
        }),
      }
    )
  ),
  s(
    {
      trig = "for ", -- new line version
      snippetType = "autosnippet",
      condition = custom_conds.is_in_code * expand_conds.line_begin,
    },
    fmt(
      [[
        for {} in {}:
            {}
      ]],
      {
        i(1, "var"),
        c(2, {
          i(nil, "iterable"),
          sn(nil, { t("enumerate("), i(1, "iterable"), t(")") }),
          sn(nil, { t("range("), i(1, "integer"), t(")") }),
          sn(nil, { t("zip("), i(1, "iterables"), t(")") }),
        }),
        i(3, "pass"),
      }
    )
  ),
  s(
    {
      trig = "for ", -- inline version
      snippetType = "autosnippet",
      condition = custom_conds.is_in_code * -expand_conds.line_begin,
    },
    fmt(
      [[
        for {} in {}
      ]],
      {
        i(1, "var"),
        c(2, {
          i(nil, "iterable"),
          sn(nil, { t("enumerate("), i(1, "iterable"), t(")") }),
          sn(nil, { t("range("), i(1, "integers"), t(")") }),
          sn(nil, { t("zip("), i(1, "iterables"), t(")") }),
        }),
      }
    )
  ),
  s(
    {
      trig = "def ",
      snippetType = "autosnippet",
      condition = custom_conds.is_in_code * expand_conds.line_begin,
    },
    fmt(
      [[
        def {}({}) -> {}:
            {}
      ]],
      {
        i(1, "function"),
        c(2, {
          t(""),
          sn(nil, { t("self"), i(1) }),
          sn(nil, { t("cls"), i(1) }),
        }),
        i(3, "None"),
        i(4, "pass"),
      }
    )
  ),
  s(
    {
      trig = [["""]],
      snippetType = "autosnippet",
      condition = custom_conds.is_in_code * expand_conds.line_begin,
    },
    fmt(
      [[
        """{}{}
      ]],
      {
        i(1, "Description."),
        c(2, {
          t(""),
          sn(nil, {
            t({ "", "", "Args:", "    " }),
            i(1),
            t({ "", "", "Returns:", "    " }),
            i(2),
            t({ "", "" }),
          }),
          sn(nil, {
            t({ "", "", "Attributes:", "    " }),
            i(1),
            t({ "", "" }),
          }),
        }),
      }
    )
  ),
  s(
    "__main__",
    fmt(
      [[
        if __name__ == "__main__":
            {}
      ]],
      {
        i(1, "pass"),
      }
    )
  ),
}
