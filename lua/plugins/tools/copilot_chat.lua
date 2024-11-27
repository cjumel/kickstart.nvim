-- CopilotChat.nvim
--
-- CopilotChat.nvim is a plugin to chat with GitHub Copilot directly in Neovim. It is a great complement to the standard
-- Copilot virtual completion, as it provides chat features like question answering or code generation or explanation,
-- directly integrated in Neovim and with the same Copilot subscription.

local custom_actions = require("plugins.tools.copilot_chat.actions")
local nvim_config = require("nvim_config")

return {
  "CopilotC-Nvim/CopilotChat.nvim",
  cond = not (nvim_config.light_mode or nvim_config.disable_copilot),
  branch = "canary",
  dependencies = {
    "zbirenbaum/copilot.lua",
    "nvim-lua/plenary.nvim",
  },
  keys = {
    { "<leader>cc", custom_actions.toggle, mode = { "n", "v" }, desc = "[C]hat: toggle" },
    { "<leader>cs", custom_actions.stop, mode = { "n", "v" }, desc = "[C]hat: [S]top" },
    { "<leader>cr", custom_actions.reset, mode = { "n", "v" }, desc = "[C]hat: [R]eset" },
    { "<leader>cm", custom_actions.select_model, desc = "[C]hat: select [M]odel" },
    { "<leader>ca", custom_actions.select_action, mode = { "n", "v" }, desc = "[C]hat: select [A]ction" },
  },
  opts = {
    show_folds = false, -- I find the folds a bit ugly and out of place
    chat_autocomplete = false, -- Auto-complete is not integrated with nvim-cmp, and I don't like how it works
    mappings = {
      complete = { insert = "" }, -- Disable auto-complete altogether
      close = { normal = "q", insert = "<C-c>" },
      reset = { normal = "<localleader>r", insert = "" },
      submit_prompt = { normal = "<CR>", insert = "<M-CR>" }, -- <C-CR>
      toggle_sticky = { normal = "<localleader>t" },
      accept_diff = { normal = "<localleader>a", insert = "" },
      jump_to_diff = { normal = "<localleader>j" },
      quickfix_diffs = { normal = "<localleader>q" },
      yank_diff = { normal = "<localleader>y" },
      show_diff = { normal = "<localleader>d" },
      show_system_prompt = { normal = "<localleader>p" },
      show_user_selection = { normal = "<localleader>s" },
      show_user_context = { normal = "<localleader>c" },
      show_help = { normal = "g?" },
    },
  },
}
