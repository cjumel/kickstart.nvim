-- inc-rename.nvim
--
-- inc-rename.nvim is a small plugin providing a command for LSP renaming in an incremental fashion, that is with
-- target highlighting & immediate visual feedback of the result, thanks to Neovim's command preview feature. Besides,
-- it makes the renaming prompt located at the cursor position, which is more convenient than the default centered
-- position. All in all, it makes the LSP renaming a sensibly better experience, in my opinion.

return {
  "smjonas/inc-rename.nvim",
  cond = not require("config")["light_mode"],
  lazy = true,
  opts = { save_in_cmdline_history = false }, -- Don't save command in history, like the builtin LSP rename
}
