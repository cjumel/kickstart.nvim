-- CopilotChat.nvim
--
-- CopilotChat.nvim is a Neovim plugin that brings GitHub Copilot Chat capabilities directly into your editor. It is
-- nicely complementary with GitHub Copilot completion plugins, like the official copilot.vim, or copilot.lua, as it
-- provides chat features with the same GitHub Copilot subscription.

return {
  "CopilotC-Nvim/CopilotChat.nvim",
  cond = Metaconfig.enable_all_plugins or not Metaconfig.disable_copilot,
  dependencies = {
    "zbirenbaum/copilot.lua",
    "nvim-lua/plenary.nvim",
  },
  keys = {
    { "<leader>aa", function() require("CopilotChat").toggle() end, mode = { "n", "x" }, desc = "[A]I: toggle chat" },
    { "<leader>as", function() require("CopilotChat").stop() end, mode = { "n", "x" }, desc = "[A]I: [S]top" },
    { "<leader>ar", function() require("CopilotChat").reset() end, mode = { "n", "x" }, desc = "[A]I: [R]eset" },
    {
      "<leader>ap",
      function() require("CopilotChat").select_prompt() end,
      mode = { "n", "x" },
      desc = "[A]I: select [P]rompt",
    },
    { "<leader>am", function() require("CopilotChat").select_model() end, desc = "[A]I: select [M]odel" },
  },
  opts = {
    show_folds = false,
    mappings = {
      complete = { insert = "<Tab>" },
      close = { normal = "q", insert = "" },
      reset = { normal = "<localleader>r", insert = "" },
      submit_prompt = { normal = "<CR>", insert = "" },
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
  config = function(_, opts)
    require("CopilotChat").setup(opts)

    vim.api.nvim_create_autocmd("BufEnter", {
      pattern = "copilot-chat",
      callback = function() vim.opt_local.completeopt = "noinsert,popup" end,
    })
  end,
}
