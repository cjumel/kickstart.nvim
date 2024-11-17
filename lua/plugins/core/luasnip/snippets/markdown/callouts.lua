-- List of callouts and symbols taken from https://github.com/MeanderingProgrammer/render-markdown.nvim/wiki/Callouts

local conds = require("plugins.core.luasnip.conditions")
local ls = require("luasnip")

local s = ls.snippet
local t = ls.text_node

return {
  s({
    trig = "NOTE",
    desc = "󰋽 Note",
    show_condition = conds.make_prefix_condition("[!"),
  }, { t("NOTE") }),
  s({
    trig = "TIP",
    desc = "󰌶 Tip",
    show_condition = conds.make_prefix_condition("[!"),
  }, { t("TIP") }),
  s({
    trig = "IMPORTANT",
    desc = "󰅾 Important",
    show_condition = conds.make_prefix_condition("[!"),
  }, { t("IMPORTANT") }),
  s({
    trig = "WARNING",
    desc = "󰀪 Warning",
    show_condition = conds.make_prefix_condition("[!"),
  }, { t("WARNING") }),
  s({
    trig = "CAUTION",
    desc = "󰳦 Caution",
    show_condition = conds.make_prefix_condition("[!"),
  }, { t("CAUTION") }),
  s({
    trig = "ABSTRACT",
    desc = "󰨸 Abstract",
    show_condition = conds.make_prefix_condition("[!"),
  }, { t("ABSTRACT") }),
  s({
    trig = "SUMMARY",
    desc = "󰨸 Summary",
    show_condition = conds.make_prefix_condition("[!"),
  }, { t("SUMMARY") }),
  s({
    trig = "TLDR",
    desc = "󰨸 Tldr",
    show_condition = conds.make_prefix_condition("[!"),
  }, { t("TLDR") }),
  s({
    trig = "INFO",
    desc = "󰋽 Info",
    show_condition = conds.make_prefix_condition("[!"),
  }, { t("INFO") }),
  s({
    trig = "TODO",
    desc = "󰗡 Todo",
    show_condition = conds.make_prefix_condition("[!"),
  }, { t("TODO") }),
  s({
    trig = "HINT",
    desc = "󰌶 Hint",
    show_condition = conds.make_prefix_condition("[!"),
  }, { t("HINT") }),
  s({
    trig = "SUCCESS",
    desc = "󰄬 Success",
    show_condition = conds.make_prefix_condition("[!"),
  }, { t("SUCCESS") }),
  s({
    trig = "CHECK",
    desc = "󰄬 Check",
    show_condition = conds.make_prefix_condition("[!"),
  }, { t("CHECK") }),
  s({
    trig = "DONE",
    desc = "󰄬 Done",
    show_condition = conds.make_prefix_condition("[!"),
  }, { t("DONE") }),
  s({
    trig = "QUESTION",
    desc = "󰘥 Question",
    show_condition = conds.make_prefix_condition("[!"),
  }, { t("QUESTION") }),
  s({
    trig = "HELP",
    desc = "󰘥 Help",
    show_condition = conds.make_prefix_condition("[!"),
  }, { t("HELP") }),
  s({
    trig = "FAQ",
    desc = "󰘥 Faq",
    show_condition = conds.make_prefix_condition("[!"),
  }, { t("FAQ") }),
  s({
    trig = "ATTENTION",
    desc = "󰀪 Attention",
    show_condition = conds.make_prefix_condition("[!"),
  }, { t("ATTENTION") }),
  s({
    trig = "FAILURE",
    desc = "󰅖 Failure",
    show_condition = conds.make_prefix_condition("[!"),
  }, { t("FAILURE") }),
  s({
    trig = "FAIL",
    desc = "󰅖 Fail",
    show_condition = conds.make_prefix_condition("[!"),
  }, { t("FAIL") }),
  s({
    trig = "MISSING",
    desc = "󰅖 Missing",
    show_condition = conds.make_prefix_condition("[!"),
  }, { t("MISSING") }),
  s({
    trig = "DANGER",
    desc = "󱐌 Danger",
    show_condition = conds.make_prefix_condition("[!"),
  }, { t("DANGER") }),
  s({
    trig = "ERROR",
    desc = "󱐌 Error",
    show_condition = conds.make_prefix_condition("[!"),
  }, { t("ERROR") }),
  s({
    trig = "BUG",
    desc = "󰨰 Bug",
    show_condition = conds.make_prefix_condition("[!"),
  }, { t("BUG") }),
  s({
    trig = "EXAMPLE",
    desc = "󰉹 Example",
    show_condition = conds.make_prefix_condition("[!"),
  }, { t("EXAMPLE") }),
  s({
    trig = "QUOTE",
    desc = "󱆨 Quote",
    show_condition = conds.make_prefix_condition("[!"),
  }, { t("QUOTE") }),
  s({
    trig = "CITE",
    desc = "󱆨 Cite",
    show_condition = conds.make_prefix_condition("[!"),
  }, { t("CITE") }),
}
