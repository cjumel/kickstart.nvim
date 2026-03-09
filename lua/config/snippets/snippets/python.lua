local ls = require("luasnip")
local ls_extras = require("luasnip.extras")
local snippet_conds = require("config.snippets.conditions")

local c = ls.choice_node
local i = ls.insert_node
local r = ls.restore_node
local rep = ls_extras.rep
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node

return {

  -- [[ Code keywords ]]

  s(
    { trig = "class", show_condition = snippet_conds.empty_line * snippet_conds.code },
    { t("class "), i(1), t({ ":", "\t" }), i(2, "pass") }
  ),

  s({ trig = "def", show_condition = snippet_conds.empty_line * snippet_conds.code }, {
    c(1, {
      sn(nil, {
        t("def "),
        r(1, "name", i(nil)),
        t("("),
        r(2, "args", i(nil)),
        t(") -> "),
        i(3, "None"),
        t({ ":", "\t" }),
        r(4, "content", i(nil, "pass")),
      }),
      sn(nil, { t("def "), r(1, "name"), t("("), r(2, "args"), t({ "):", "\t" }), r(3, "content") }),
    }),
  }),
  s({ trig = "async def", show_condition = snippet_conds.empty_line * snippet_conds.code }, {
    c(1, {
      sn(nil, {
        t("async def "),
        r(1, "name", i(nil)),
        t("("),
        r(2, "args", i(nil)),
        t(") -> "),
        i(3, "None"),
        t({ ":", "\t" }),
        r(4, "content", i(nil, "pass")),
      }),
      sn(nil, { t("async def "), r(1, "name"), t("("), r(2, "args"), t({ "):", "\t" }), r(3, "content") }),
    }),
  }),

  s(
    { trig = "elif", show_condition = snippet_conds.empty_line * snippet_conds.code },
    { t("elif "), i(1), t({ ":", "\t" }), i(2, "pass") }
  ),

  s(
    { trig = "else", show_condition = snippet_conds.empty_line * snippet_conds.code },
    { t({ "else:", "\t" }), i(1, "pass") }
  ),

  s(
    { trig = "for", show_condition = snippet_conds.empty_line * snippet_conds.code },
    { t("for "), i(1), t(" in "), i(2), t({ ":", "\t" }), i(3, "pass") }
  ),
  s(
    { trig = "async for", show_condition = snippet_conds.empty_line * snippet_conds.code },
    { t("async for "), i(1), t(" in "), i(2), t({ ":", "\t" }), i(3, "pass") }
  ),

  s({ trig = "from … import", show_condition = snippet_conds.empty_line * snippet_conds.code }, {
    c(1, {
      sn(nil, { t("from "), r(1, "module", i(nil)), t(" import "), r(2, "content", i(nil)) }),
      sn(nil, { t("from "), r(1, "module"), t(" import "), r(2, "content"), t(" as "), i(3) }),
    }),
  }),

  s(
    { trig = "if", show_condition = snippet_conds.empty_line * snippet_conds.code },
    { t("if "), i(1), t({ ":", "\t" }), i(2, "pass") }
  ),
  s(
    { trig = "if … main", show_condition = snippet_conds.empty_line * snippet_conds.code },
    { t({ 'if __name__ == "__main__":', "\t" }), i(1, "pass") }
  ),
  s({ trig = "if … isinstance … raise", show_condition = snippet_conds.empty_line * snippet_conds.code }, {
    c(1, {
      sn(nil, {
        t("if isinstance("),
        r(1, "var", i(nil)),
        t(", "),
        r(2, "type", i(nil)),
        t({ "):", "\t" }),
        t([[raise TypeError("Expected ']]),
        rep(1),
        t([[' not to be of type ']]),
        rep(2),
        t([['")]]),
        i(3),
      }),
      sn(nil, {
        t("if not isinstance("),
        r(1, "var"),
        t(", "),
        r(2, "type"),
        t({ "):", "\t" }),
        t([[raise TypeError(f"Expected ']]),
        rep(1),
        t([[' to be of type ']]),
        rep(2),
        t([[' but got '{type(]]),
        rep(1),
        t([[)}'")]]),
        i(3),
      }),
    }),
  }),
  s({ trig = "if … None … raise", show_condition = snippet_conds.empty_line * snippet_conds.code }, {
    c(1, {
      sn(nil, {
        t("if "),
        r(1, "var", i(nil)),
        t({ " is None:", "\t" }),
        t([[raise ValueError("Expected ']]),
        rep(1),
        t([[' not to be None")]]),
        i(2),
      }),
      sn(nil, {
        t("if "),
        r(1, "var"),
        t({ " is not None:", "\t" }),
        t([[raise ValueError(f"Expected ']]),
        rep(1),
        t([[' to be None but got '{]]),
        rep(1),
        t([[}'")]]),
        i(2),
      }),
    }),
  }),

  s({ trig = "import", show_condition = snippet_conds.empty_line * snippet_conds.code }, {
    c(1, {
      sn(nil, { t("import "), r(1, "module", i(nil)) }),
      sn(nil, { t("import "), r(1, "module"), t(" as "), i(2) }),
    }),
  }),

  s({ trig = "try … except", show_condition = snippet_conds.empty_line * snippet_conds.code }, {
    t({ "try:", "\t" }),
    i(1, "pass"),
    t({ "", "except " }),
    i(2, "Exception"),
    t({ ":", "\t" }),
    i(3, "pass"),
  }),

  s(
    { trig = "with", show_condition = snippet_conds.empty_line * snippet_conds.code },
    { t("with "), i(1), t({ ":", "\t" }), i(2, "pass") }
  ),
  s(
    { trig = "async with", show_condition = snippet_conds.empty_line * snippet_conds.code },
    { t("async with "), i(1), t({ ":", "\t" }), i(2, "pass") }
  ),

  s(
    { trig = "while", show_condition = snippet_conds.empty_line * snippet_conds.code },
    { t("while "), i(1), t({ ":", "\t" }), i(2, "pass") }
  ),

  -- [[ Comment keywords ]]

  s({
    trig = "noqa",
    show_condition = snippet_conds.comment_start * snippet_conds.line_end,
    desc = "Ignore Flake8 or Ruff lint issues",
  }, {
    c(1, {
      sn(nil, { t("noqa: "), i(1) }),
      sn(nil, { t("noqa"), i(1) }),
    }),
  }),

  s({
    trig = "pragma: no cover",
    show_condition = snippet_conds.comment_start * snippet_conds.line_end,
    desc = "Exclude from coverage.py coverage report",
  }, { t("pragma: no cover") }),

  s({
    trig = "pyright: ignore",
    show_condition = snippet_conds.comment_start * snippet_conds.line_end,
    desc = "Ignore pyright issues",
  }, {
    c(1, {
      sn(nil, { t("pyright: ignore["), i(1), t("]") }),
      sn(nil, { t("pyright: ignore"), i(1) }),
    }),
  }),

  s({
    trig = "ruff: noqa",
    show_condition = snippet_conds.comment_start * snippet_conds.line_end,
    desc = "Ignore Ruff warnings for the whole file (should be near the beginning of the file)",
  }, {
    c(1, {
      sn(nil, { t("ruff: noqa: "), i(1) }),
      sn(nil, { t("ruff: noqa"), i(1) }),
    }),
  }),

  s({
    trig = "ty: ignore",
    show_condition = snippet_conds.comment_start * snippet_conds.line_end,
    desc = "Ignore ty issues",
  }, {
    c(1, {
      sn(nil, { t("ty: ignore["), i(1), t("]") }),
      sn(nil, { t("ty: ignore"), i(1) }),
    }),
  }),

  s({
    trig = "type: ignore",
    show_condition = snippet_conds.comment_start * snippet_conds.line_end,
    desc = "Ignore mypy or Pyright typing issues",
  }, {
    c(1, {
      sn(nil, { t("type: ignore["), i(1), t("]") }),
      sn(nil, { t("type: ignore"), i(1) }),
    }),
  }),
}
