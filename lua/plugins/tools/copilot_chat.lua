-- CopilotChat.nvim
--
-- CopilotChat.nvim is a plugin to chat with GitHub Copilot in Neovim. It is a great complement to Copilot.vim, as
-- Copilot.vim provides inline code suggestions and CopilotChat.nvim provides chat features, like question answering
-- or code explanation.

return {
  "CopilotC-Nvim/CopilotChat.nvim",
  cond = not (require("config")["light_mode"] or require("config")["disable_copilot"]),
  branch = "canary",
  dependencies = {
    "github/copilot.vim",
    "nvim-lua/plenary.nvim",
  },
  keys = {
    {
      "<leader>cc",
      function() require("CopilotChat").toggle() end,
      mode = { "n", "v" },
      desc = "[C]hat: toggle",
    },
    {
      "<leader>ca",
      function() require("CopilotChat.actions").pick(require("CopilotChat.actions").prompt_actions()) end,
      mode = { "n", "v" },
      desc = "[C]hat: [A]ction selection",
    },
    {
      "<leader>cm",
      function() require("CopilotChat").select_model() end,
      desc = "[C]hat: [M]odel selection",
    },
  },
  opts = {
    show_folds = false, -- Don't show a fold for each section of the chat
    context = "buffer", -- Pass the current buffer as context to the chat
    mappings = {
      complete = { normal = "", insert = "" }, -- Disabled in favor of nvim-cmp integration
      close = { normal = "q", insert = "<C-c>" },
      reset = { normal = "<localleader>r", insert = "" },
      submit_prompt = { normal = "<CR>", insert = "<C-s>" },
      accept_diff = { normal = "<localleader>a", insert = "" },
      yank_diff = { normal = "<localleader>y", insert = "" },
      show_diff = { normal = "<localleader>d", insert = "" },
      show_system_prompt = { normal = "<localleader>p", insert = "" },
      show_user_selection = { normal = "<localleader>s", insert = "" },
    },
  },
  config = function(_, opts)
    require("CopilotChat").setup(opts)
    require("CopilotChat.integrations.cmp").setup()
  end,
}
