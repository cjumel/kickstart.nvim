-- List of callouts and symbols taken from https://github.com/MeanderingProgrammer/render-markdown.nvim/wiki/Callouts

local ls = require("luasnip")

local s = ls.snippet
local t = ls.text_node

return {
  s({ trig = "[!NOTE]", desc = "󰋽 Note" }, { t("[!NOTE") }),
  s({ trig = "[!TIP]", desc = "󰌶 Tip" }, { t("[!TIP]") }),
  s({ trig = "[!IMPORTANT]", desc = "󰅾 Important" }, { t("[!IMPORTANT") }),
  s({ trig = "[!WARNING]", desc = "󰀪 Warning" }, { t("[!WARNING") }),
  s({ trig = "[!CAUTION]", desc = "󰳦 Caution" }, { t("[!CAUTION") }),
  s({ trig = "[!ABSTRACT]", desc = "󰨸 Abstract" }, { t("[!ABSTRACT") }),
  s({ trig = "[!SUMMARY]", desc = "󰨸 Summary" }, { t("[!SUMMARY") }),
  s({ trig = "[!TLDR]", desc = "󰨸 Tldr" }, { t("[!TLDR") }),
  s({ trig = "[!INFO]", desc = "󰋽 Info" }, { t("[!INFO") }),
  s({ trig = "[!TODO]", desc = "󰗡 Todo" }, { t("[!TODO") }),
  s({ trig = "[!HINT]", desc = "󰌶 Hint" }, { t("[!HINT") }),
  s({ trig = "[!SUCCESS]", desc = "󰄬 Success" }, { t("[!SUCCESS") }),
  s({ trig = "[!CHECK]", desc = "󰄬 Check" }, { t("[!CHECK") }),
  s({ trig = "[!DONE]", desc = "󰄬 Done" }, { t("[!DONE") }),
  s({ trig = "[!QUESTION]", desc = "󰘥 Question" }, { t("[!QUESTION") }),
  s({ trig = "[!HELP]", desc = "󰘥 Help" }, { t("[!HELP") }),
  s({ trig = "[!FAQ]", desc = "󰘥 Faq" }, { t("[!FAQ") }),
  s({ trig = "[!ATTENTION]", desc = "󰀪 Attention" }, { t("[!ATTENTION") }),
  s({ trig = "[!FAILURE]", desc = "󰅖 Failure" }, { t("[!FAILURE") }),
  s({ trig = "[!FAIL]", desc = "󰅖 Fail" }, { t("[!FAIL") }),
  s({ trig = "[!MISSING]", desc = "󰅖 Missing" }, { t("[!MISSING") }),
  s({ trig = "[!DANGER]", desc = "󱐌 Danger" }, { t("[!DANGER") }),
  s({ trig = "[!ERROR]", desc = "󱐌 Error" }, { t("[!ERROR") }),
  s({ trig = "[!BUG]", desc = "󰨰 Bug" }, { t("[!BUG") }),
  s({ trig = "[!EXAMPLE]", desc = "󰉹 Example" }, { t("[!EXAMPLE") }),
  s({ trig = "[!QUOTE]", desc = "󱆨 Quote" }, { t("[!QUOTE") }),
  s({ trig = "[!CITE]", desc = "󱆨 Cite" }, { t("[!CITE") }),
}
