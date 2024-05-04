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
  keys = {
    { "<leader>cc", "<cmd>CopilotChatToggle<CR>", mode = { "n", "v" }, desc = "[C]opilot: toggle chat" },
    { "<leader>ce", "<cmd>CopilotChatExplain<CR>", mode = { "n", "v" }, desc = "[C]opilot: [E]xplain" },
    { "<leader>cr", "<cmd>CopilotChatReview<CR>", mode = { "n", "v" }, desc = "[C]opilot: [R]eview" },
    { "<leader>cf", "<cmd>CopilotChatFix<CR>", mode = { "n", "v" }, desc = "[C]opilot: [F]ix" },
    { "<leader>co", "<cmd>CopilotChatOptimize<CR>", mode = { "n", "v" }, desc = "[C]opilot: [O]ptimize" },
    { "<leader>cd", "<cmd>CopilotChatDocs<CR>", mode = { "n", "v" }, desc = "[C]opilot: [D]ocument" },
    { "<leader>ct", "<cmd>CopilotChatTests<CR>", mode = { "n", "v" }, desc = "[C]opilot: [T]est" },
    { "<leader>cx", "<cmd>CopilotChatFixDiagnostic<CR>", mode = { "n", "v" }, desc = "[C]opilot: fix diagnostics" },
    { "<leader>cg", "<cmd>CopilotChatCommitStaged<CR>", mode = { "n", "v" }, desc = "[C]opilot: [G]it commit" },
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
