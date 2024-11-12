-- Commands to write buffer(s) without triggering auto-commands (e.g. to avoid triggering format-on-save)
vim.api.nvim_create_user_command("W", function(args)
  if args.bang then
    vim.cmd("noautocmd w!")
  else
    vim.cmd("noautocmd w")
  end
end, { desc = "Write buffer without auto-commands", bang = true })
vim.api.nvim_create_user_command("Wq", function(args)
  if args.bang then
    vim.cmd("noautocmd wq!")
  else
    vim.cmd("noautocmd wq")
  end
end, { desc = "Write buffer and quite without auto-commands", bang = true })
vim.api.nvim_create_user_command("Wqa", function(args)
  if args.bang then
    vim.cmd("noautocmd wqa!")
  else
    vim.cmd("noautocmd wqa")
  end
end, { desc = "Write all buffers and quit without auto-commands", bang = true })

-- Command to close all buffers at once
vim.api.nvim_create_user_command("Bd", function(args)
  if args.bang then
    vim.cmd("bufdo bd!")
  else
    vim.cmd("bufdo bd")
  end
end, { desc = "Close all opened buffers", bang = true })
