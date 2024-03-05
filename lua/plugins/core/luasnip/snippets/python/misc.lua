local ls = require("luasnip")

local c = ls.choice_node
local d = ls.dynamic_node
local i = ls.insert_node
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node

local fmt = require("luasnip.extras.fmt").fmt

local custom_show_conds = require("plugins.core.luasnip.show_conds")
local show_conds = require("luasnip.extras.conditions.show")

return {
  s({
    trig = "import",
    show_condition = (
      custom_show_conds.is_in_code
      * custom_show_conds.line_begin
      * show_conds.line_end
    ),
  }, fmt("import {}", { i(1, "module") })),
  s({
    trig = "import-as",
    show_condition = (
      custom_show_conds.is_in_code
      * custom_show_conds.line_begin
      * show_conds.line_end
    ),
  }, fmt("import {} as {}", { i(1, "module"), i(2, "name") })),
  s({
    trig = "from-import",
    show_condition = (
      custom_show_conds.is_in_code
      * custom_show_conds.line_begin
      * show_conds.line_end
    ),
  }, fmt("from {} import {}", { i(1, "module"), i(2, "var") })),
  s({
    trig = "from-import-as",
    show_condition = (
      custom_show_conds.is_in_code
      * custom_show_conds.line_begin
      * show_conds.line_end
    ),
  }, fmt("from {} import {} as {}", { i(1, "module"), i(2, "var"), i(3, "name") })),
  s(
    {
      trig = "if",
      show_condition = (
        custom_show_conds.is_in_code
        * custom_show_conds.line_begin
        * show_conds.line_end
      ),
    },
    fmt(
      [[
        if {}:
            {}
      ]],
      { i(1, "cond"), i(2, "pass") }
    )
  ),
  s({
    trig = "if", -- Inline version
    show_condition = custom_show_conds.is_in_code * -custom_show_conds.line_begin,
  }, fmt("if {} else {}", { i(1, "cond"), i(2, "None") })),
  s(
    {
      trig = "elif",
      show_condition = (
        custom_show_conds.is_in_code
        * custom_show_conds.line_begin
        * show_conds.line_end
      ),
    },
    fmt(
      [[
        elif {}:
            {}
      ]],
      { i(1, "cond"), i(2, "pass") }
    )
  ),
  s(
    {
      trig = "else",
      show_condition = (
        custom_show_conds.is_in_code
        * custom_show_conds.line_begin
        * show_conds.line_end
      ),
    },
    fmt(
      [[
        else:
            {}
      ]],
      { i(1, "pass") }
    )
  ),
  s(
    {
      trig = "for",
      show_condition = (
        custom_show_conds.is_in_code
        * custom_show_conds.line_begin
        * show_conds.line_end
      ),
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
      trig = "for", -- Inline version
      show_condition = custom_show_conds.is_in_code * -custom_show_conds.line_begin,
    },
    fmt("for {} in {}", {
      i(1, "var"),
      c(2, {
        i(nil, "iterable"),
        sn(nil, { t("enumerate("), i(1, "iterable"), t(")") }),
        sn(nil, { t("range("), i(1, "integer"), t(")") }),
        sn(nil, { t("zip("), i(1, "iterables"), t(")") }),
      }),
    })
  ),
  s(
    {
      trig = "while",
      show_condition = (
        custom_show_conds.is_in_code
        * custom_show_conds.line_begin
        * show_conds.line_end
      ),
    },
    fmt(
      [[
        while {}:
            {}
      ]],
      { i(1, "cond"), i(2, "pass") }
    )
  ),
  s(
    {
      trig = "def",
      show_condition = (
        custom_show_conds.is_in_code
        * custom_show_conds.line_begin
        * show_conds.line_end
      ),
    },
    fmt(
      [[
        def {}({}) -> {}:
            {}
      ]],
      {
        i(1, "function"),
        d(2, function(_)
          local node = vim.treesitter.get_node()

          local is_in_class
          if node == nil then
            is_in_class = false
          elseif node:type() == "class_definition" then
            is_in_class = true
          elseif node:parent() ~= nil and node:parent():type() == "class_definition" then
            is_in_class = true
          else
            is_in_class = false
          end

          local snippets
          if is_in_class then
            snippets = {
              c(1, {
                sn(nil, { t("self"), i(1) }),
                sn(nil, { t("cls"), i(1) }),
                sn(nil, { i(1) }),
              }),
            }
          else
            snippets = { i(1) }
          end
          return sn(nil, snippets)
        end),
        i(3, "None"),
        i(4, "pass"),
      }
    )
  ),
  s(
    {
      trig = "lambda",
      show_condition = custom_show_conds.is_in_code * -custom_show_conds.line_begin,
    },
    fmt(
      [[
        lambda {}: {}
      ]],
      {
        i(1, "x"),
        i(2, "pass"),
      }
    )
  ),
  s(
    {
      trig = "class",
      show_condition = (
        custom_show_conds.is_in_code
        * custom_show_conds.line_begin
        * show_conds.line_end
      ),
    },
    fmt(
      [[
        class {}:
            {}
      ]],
      { i(1, "Name"), i(2, "pass") }
    )
  ),
  s(
    {
      trig = "__main__",
      show_condition = (
        custom_show_conds.is_in_code
        * custom_show_conds.line_begin
        * show_conds.line_end
      ),
    },
    fmt(
      [[
        if __name__ == "__main__":
            {}
      ]],
      { i(1, "pass") }
    )
  ),
}
