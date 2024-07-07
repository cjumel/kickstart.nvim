-- CopilotChat.nvim
--
-- CopilotChat.nvim is a plugin to chat with GitHub Copilot in Neovim. It is a great complement to Copilot.vim, as
-- Copilot.vim provides inline code suggestions and CopilotChat.nvim provides chat features, like question answering
-- or code explanation.

return {
  "CopilotC-Nvim/CopilotChat.nvim",
  branch = "canary",
  dependencies = {
    "github/copilot.vim",
    "nvim-lua/plenary.nvim",
  },
  keys = function()
    local chat = require("CopilotChat")
    local chat_actions = require("CopilotChat.actions")

    return {
      { "<leader>cc", chat.toggle, desc = "[C]hat: toggle", mode = { "n", "v" } },
      {
        "<leader>ca",
        function() chat_actions.pick(chat_actions.prompt_actions()) end,
        desc = "[C]hat: [A]ctions",
        mode = { "n", "v" },
      },
    }
  end,
  opts = {
    show_folds = false,
    show_help = false,
    auto_insert_mode = true,
    context = "buffer", -- Pass the current buffer as context to the chat (default is file name)
    mappings = {
      complete = { insert = false }, -- To let <Tab> for regular Copilot completion
      reset = { normal = "gr", insert = false }, -- To let <C-l> for window change
    },
  },
}
