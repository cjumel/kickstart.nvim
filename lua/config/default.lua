vim.g.neovim_config = {
  -- Set light_mode to true to disable all the plugins related to GitHub's Copilot or to external tools managed with
  --  Mason. This mode activates all other options below to their full extent, which means the other options are useless
  --  in this case.
  light_mode = false,
  -- Set disable_copilot to true to disable GitHub's Copilot & its related plugins
  disable_copilot = false,
  -- Set disable_format_on_save_on_filetypes to an array of filetypes to disable format-on-save on those filetypes, or
  --  to "*" to disable it on all files
  disable_format_on_save_on_filetypes = false,
  -- Set disable_lint_on_filetypes to an array of filetypes to disable linting on those filetypes, or to "*" to disable
  --  it on all files
  disable_lint_on_filetypes = false,
}
