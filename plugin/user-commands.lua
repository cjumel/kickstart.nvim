-- Command to write the current buffer without any auto-command, for instance to prevent triggering format-on-save
vim.api.nvim_create_user_command("W", "noautocmd w", { desc = "Write buffer without auto-commands" })
