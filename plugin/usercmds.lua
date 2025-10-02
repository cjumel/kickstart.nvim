-- Switch autoformat mode, between "disable", "auto" and "force", globally or per-buffer (the later taking precedence
-- over the former)
local function enable_autoformat(args)
  if args.args == "all" and args.bang then
    vim.g.autoformat_mode = "force"
    vim.notify("Autoformat enabled globally (force)", vim.log.levels.INFO, { title = "Autoformat" })
  elseif args.args == "all" then
    vim.g.autoformat_mode = "auto"
    vim.notify("Autoformat enabled globally (auto)", vim.log.levels.INFO, { title = "Autoformat" })
  elseif args.bang then
    vim.b.autoformat_mode = "force"
    vim.notify("Autoformat enabled for current buffer (force)", vim.log.levels.INFO, { title = "Autoformat" })
  else
    vim.b.autoformat_mode = "auto"
    vim.notify("Autoformat enabled for current buffer (auto)", vim.log.levels.INFO, { title = "Autoformat" })
  end
end
local function disable_autoformat(args)
  if args.args == "all" then
    vim.g.autoformat_mode = "disable"
    vim.notify("Autoformat disabled globally", vim.log.levels.INFO, { title = "Autoformat" })
  else
    vim.b.autoformat_mode = "disable"
    vim.notify("Autoformat disabled for current buffer", vim.log.levels.INFO, { title = "Autoformat" })
  end
end
local function autoformat_is_disabled(args)
  if args.args == "all" then
    return vim.g.autoformat_mode == "disable"
  else
    return vim.b.autoformat_mode == "disable"
  end
end
local function toggle_autoformat(args)
  if autoformat_is_disabled(args) then
    enable_autoformat(args)
  else
    disable_autoformat(args)
  end
end
vim.api.nvim_create_user_command("AutoformatEnable", enable_autoformat, {
  desc = "Enable autoformat",
  bang = true,
  nargs = "?",
  complete = function() return { "all" } end,
})
vim.api.nvim_create_user_command("AutoformatDisable", disable_autoformat, {
  desc = "Disable autoformat",
  nargs = "?",
  complete = function() return { "all" } end,
})
vim.api.nvim_create_user_command("AutoformatToggle", toggle_autoformat, {
  desc = "Toggle autoformat",
  bang = true,
  nargs = "?",
  complete = function() return { "all" } end,
})

-- Switch lint mode, between "disable", "auto" and "force", globally or per-buffer (the later taking precedence over the
-- former)
local function enable_lint(args)
  if args.args == "all" and args.bang then
    vim.g.lint_mode = "force"
    vim.notify("Lint enabled globally (force)", vim.log.levels.INFO, { title = "Lint" })
  elseif args.args == "all" then
    vim.g.lint_mode = "auto"
    vim.notify("Lint enabled globally (auto)", vim.log.levels.INFO, { title = "Lint" })
  elseif args.bang then
    vim.b.lint_mode = "force"
    vim.notify("Lint enabled for current buffer (force)", vim.log.levels.INFO, { title = "Lint" })
  else
    vim.b.lint_mode = "auto"
    vim.notify("Lint enabled for current buffer (auto)", vim.log.levels.INFO, { title = "Lint" })
  end
end
local function disable_lint(args)
  if args.args == "all" then
    vim.g.lint_mode = "disable"
    vim.notify("Lint disabled globally", vim.log.levels.INFO, { title = "Lint" })
  else
    vim.b.lint_mode = "disable"
    vim.notify("Lint disabled for current buffer", vim.log.levels.INFO, { title = "Lint" })
  end
  vim.diagnostic.reset() -- Discard existing diagnotics
end
local function lint_is_disabled(args)
  if args.args == "all" then
    return vim.g.lint_mode == "disable"
  else
    return vim.b.lint_mode == "disable"
  end
end
local function toggle_lint(args)
  if lint_is_disabled(args) then
    enable_lint(args)
  else
    disable_lint(args)
  end
end
vim.api.nvim_create_user_command("LintEnable", enable_lint, {
  desc = "Enable lint",
  bang = true,
  nargs = "?",
  complete = function() return { "all" } end,
})
vim.api.nvim_create_user_command("LintDisable", disable_lint, {
  desc = "Disable lint",
  nargs = "?",
  complete = function() return { "all" } end,
})
vim.api.nvim_create_user_command("LintToggle", toggle_lint, {
  desc = "Toggle lint",
  bang = true,
  nargs = "?",
  complete = function() return { "all" } end,
})
