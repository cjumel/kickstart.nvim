local conds = require("plugins.core.luasnip.conditions")
local ls = require("luasnip")
local ls_show_conds = require("luasnip.extras.conditions.show")

local c = ls.choice_node
local d = ls.dynamic_node
local i = ls.insert_node
local r = ls.restore_node
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node

local callout_condition = conds.prefix("[!") + conds.prefix("> [!")

return {
  s({
    trig = "bold",
    desc = "`**…**`",
  }, {
    t("**"), -- Using asterix is more robust than underscores as it works also within words & is preferred by Prettier
    i(1),
    t("**"),
  }),

  s({
    trig = "bold-italic",
    desc = "`**_…_**`",
  }, {
    t("**_"), -- Using asterix is more robust than underscores as it works also within words & is preferred by Prettier
    i(1),
    t("_**"),
  }),

  s({
    trig = "callout",
    show_condition = conds.line_begin * ls_show_conds.line_end,
    desc = [[
`> [! …]`
`>`
`> …`]],
  }, {
    t("> [!"),
    i(1),
    t({ "]", ">", "> " }),
    i(2),
  }),
  -- List of callouts and symbols taken from https://github.com/MeanderingProgrammer/render-markdown.nvim/wiki/Callouts
  s({ trig = "NOTE", desc = "󰋽 Note", show_condition = callout_condition }, { t("NOTE") }),
  s({ trig = "TIP", desc = "󰌶 Tip", show_condition = callout_condition }, { t("TIP") }),
  s({ trig = "IMPORTANT", desc = "󰅾 Important", show_condition = callout_condition }, { t("IMPORTANT") }),
  s({ trig = "WARNING", desc = "󰀪 Warning", show_condition = callout_condition }, { t("WARNING") }),
  s({ trig = "CAUTION", desc = "󰳦 Caution", show_condition = callout_condition }, { t("CAUTION") }),
  s({ trig = "ABSTRACT", desc = "󰨸 Abstract", show_condition = callout_condition }, { t("ABSTRACT") }),
  s({ trig = "SUMMARY", desc = "󰨸 Summary", show_condition = callout_condition }, { t("SUMMARY") }),
  s({ trig = "TLDR", desc = "󰨸 Tldr", show_condition = callout_condition }, { t("TLDR") }),
  s({ trig = "INFO", desc = "󰋽 Info", show_condition = callout_condition }, { t("INFO") }),
  s({ trig = "TODO", desc = "󰗡 Todo", show_condition = callout_condition }, { t("TODO") }),
  s({ trig = "HINT", desc = "󰌶 Hint", show_condition = callout_condition }, { t("HINT") }),
  s({ trig = "SUCCESS", desc = "󰄬 Success", show_condition = callout_condition }, { t("SUCCESS") }),
  s({ trig = "CHECK", desc = "󰄬 Check", show_condition = callout_condition }, { t("CHECK") }),
  s({ trig = "DONE", desc = "󰄬 Done", show_condition = callout_condition }, { t("DONE") }),
  s({ trig = "QUESTION", desc = "󰘥 Question", show_condition = callout_condition }, { t("QUESTION") }),
  s({ trig = "HELP", desc = "󰘥 Help", show_condition = callout_condition }, { t("HELP") }),
  s({ trig = "FAQ", desc = "󰘥 Faq", show_condition = callout_condition }, { t("FAQ") }),
  s({ trig = "ATTENTION", desc = "󰀪 Attention", show_condition = callout_condition }, { t("ATTENTION") }),
  s({ trig = "FAILURE", desc = "󰅖 Failure", show_condition = callout_condition }, { t("FAILURE") }),
  s({ trig = "FAIL", desc = "󰅖 Fail", show_condition = callout_condition }, { t("FAIL") }),
  s({ trig = "MISSING", desc = "󰅖 Missing", show_condition = callout_condition }, { t("MISSING") }),
  s({ trig = "DANGER", desc = "󱐌 Danger", show_condition = callout_condition }, { t("DANGER") }),
  s({ trig = "ERROR", desc = "󱐌 Error", show_condition = callout_condition }, { t("ERROR") }),
  s({ trig = "BUG", desc = "󰨰 Bug", show_condition = callout_condition }, { t("BUG") }),
  s({ trig = "EXAMPLE", desc = "󰉹 Example", show_condition = callout_condition }, { t("EXAMPLE") }),
  s({ trig = "QUOTE", desc = "󱆨 Quote", show_condition = callout_condition }, { t("QUOTE") }),
  s({ trig = "CITE", desc = "󱆨 Cite", show_condition = callout_condition }, { t("CITE") }),

  s({
    trig = "code-block",
    show_condition = conds.line_begin * ls_show_conds.line_end,
    desc = [[
\`\`\`…
…
\`\`\`]],
  }, {
    t("```"),
    c(1, { i(nil), t("bash") }),
    t({ "", "" }),
    i(2),
    t({ "", "```" }),
  }),

  s({
    trig = "date",
    desc = [[
Multiple-choice snippet:
- `<%Y>-<%m>-<%d>` (ISO 8601)
- `<%d>/<%m>/<%Y>` (French)]],
  }, {
    d(
      1,
      function(_)
        return sn(nil, {
          c(1, {
            sn(nil, { t(os.date("%Y-%m-%d")), i(1) }),
            sn(nil, { t(os.date("%d/%m/%Y")), i(1) }),
          }),
        })
      end
    ),
  }),

  s({
    trig = "header",
    show_condition = conds.line_begin * ls_show_conds.line_end,
    desc = [[
Multiple-choice snippet:
- `# …`
- `## …`
- `### …`
- `#### …`
- `##### …`]],
  }, {
    c(1, {
      sn(nil, { t("# "), r(1, "content", i(nil)) }),
      sn(nil, { t("## "), r(1, "content") }),
      sn(nil, { t("### "), r(1, "content") }),
      sn(nil, { t("#### "), r(1, "content") }),
      sn(nil, { t("##### "), r(1, "content") }),
    }),
  }),

  s({
    trig = "italic",
    desc = "`_…_`",
  }, {
    t("_"),
    i(1),
    t("_"),
  }),

  s({
    trig = "link",
    desc = "`[…](…)`",
  }, {
    t("["),
    i(1, "name"),
    t("]("),
    i(2, "link"),
    t(")"),
  }),

  s({
    trig = "quote-block",
    show_condition = conds.line_begin * ls_show_conds.line_end,
    desc = [[
Multiple-choice snippet:
- `> …`
- `>> …`
- `>>> …`]],
  }, {
    c(1, {
      sn(nil, { t("> "), r(1, "content", i(nil)) }),
      sn(nil, { t(">> "), r(1, "content") }),
      sn(nil, { t(">>> "), r(1, "content") }),
    }),
  }),

  s({
    trig = "strikethrough",
    desc = "~…~",
  }, {
    t("~"),
    i(1),
    t("~"),
  }),

  s({
    trig = "time",
    desc = [[
Multiple-choice snippet:
- `<%H>:<%M>` (ISO 8601)
- `<%H>h<%M>` (French)]],
  }, {
    d(
      1,
      function(_)
        return sn(nil, {
          c(1, {
            sn(nil, { t(os.date("%H:%M")), i(1) }),
            sn(nil, { t(os.date("%Hh%M")), i(1) }),
          }),
        })
      end
    ),
  }),
}
