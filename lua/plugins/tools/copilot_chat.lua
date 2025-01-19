-- CopilotChat.nvim
--
-- CopilotChat.nvim is a plugin to chat with GitHub Copilot directly in Neovim. It is a great complement to the standard
-- Copilot virtual completion, as it provides chat features like question answering or code generation or explanation,
-- directly integrated in Neovim and with the same Copilot subscription.

return {
  "CopilotC-Nvim/CopilotChat.nvim",
  cond = not (require("conf").light_mode or require("conf").disable_copilot),
  dependencies = {
    "zbirenbaum/copilot.lua",
    "nvim-lua/plenary.nvim",
  },
  keys = {
    { "<leader>cc", function() require("CopilotChat").toggle() end, mode = { "n", "v" }, desc = "[C]hat: toggle" },
    { "<leader>cs", function() require("CopilotChat").stop() end, mode = { "n", "v" }, desc = "[C]hat: [S]top" },
    { "<leader>cr", function() require("CopilotChat").reset() end, mode = { "n", "v" }, desc = "[C]hat: [R]eset" },
    { "<leader>cm", function() require("CopilotChat").select_model() end, desc = "[C]hat: select [M]odel" },
    {
      "<leader>ca",
      function() require("CopilotChat.actions").pick(require("CopilotChat.actions").prompt_actions()) end,
      mode = { "n", "v" },
      desc = "[C]hat: select [A]ction",
    },
  },
  opts = {
    show_folds = false, -- I find the folds a bit ugly and out of place
    chat_autocomplete = false, -- Auto-complete is not integrated with nvim-cmp, and I don't like how it works
    mappings = {
      complete = { insert = "" }, -- Disable auto-complete altogether
      close = { normal = "q", insert = "<C-c>" },
      reset = { normal = "<localleader>r", insert = "" },
      submit_prompt = { normal = "<CR>", insert = "<M-CR>" }, -- <C-CR>
      toggle_sticky = { normal = "<localleader>s" },
      accept_diff = { normal = "<localleader>a", insert = "" },
      jump_to_diff = { normal = "<localleader>j" },
      quickfix_diffs = { normal = "<localleader>q" },
      yank_diff = { normal = "<localleader>y" },
      show_diff = { normal = "<localleader>d" },
      show_info = { normal = "<localleader>i" },
      show_context = { normal = "<localleader>c" },
      show_help = { normal = "g?" },
    },
  },
}
