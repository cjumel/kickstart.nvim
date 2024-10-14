-- Command to write the current buffer without any auto-command, for instance to prevent triggering format-on-save
vim.api.nvim_create_user_command("W", function(args)
  if args.bang then
    vim.cmd("noautocmd w!")
  else
    vim.cmd("noautocmd w")
  end
end, { desc = "Write buffer without auto-commands", bang = true })

-- Command to close all buffers at once
vim.api.nvim_create_user_command("Bd", function(args)
  if args.bang then
    vim.cmd("bufdo bd!")
  else
    vim.cmd("bufdo bd")
  end
end, { desc = "Close all opened buffers", bang = true })
