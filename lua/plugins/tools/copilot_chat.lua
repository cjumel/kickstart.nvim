-- CopilotChat.nvim
--
-- CopilotChat.nvim is a plugin to chat with GitHub Copilot in Neovim. It is the perfect complement to Copilot.vim, as
-- Copilot.vim provides code suggestions and CopilotChat.nvim provides chat features, like question answering or code
-- explanation.

return {
  "CopilotC-Nvim/CopilotChat.nvim",
  branch = "canary",
  dependencies = {
    "github/copilot.vim",
    "nvim-lua/plenary.nvim",
  },
  cmd = {
    "CopilotChatToggle",
    "CopilotChatExplain",
    "CopilotChatReview",
    "CopilotChatFix",
    "CopilotChatOptimize",
    "CopilotChatDocs",
    "CopilotChatTests",
    "CopilotChatFixDiagnostic",
    "CopilotChatCommitStaged",
  },
  opts = {
    show_folds = false,
    show_help = false,
    context = "buffer",
    mappings = {
      complete = { insert = false }, -- To let <Tab> for Copilot completion
      close = { normal = "q", insert = "<C-d>" },
      reset = { normal = "<C-c>", insert = "<C-c>" },
    },
  },
}
