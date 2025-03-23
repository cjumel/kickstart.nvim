-- CopilotChat.nvim
--
-- CopilotChat.nvim is a Neovim plugin that brings GitHub Copilot Chat capabilities directly into your editor. It is
-- nicely complementary with GitHub Copilot completion plugins, like the official copilot.vim, or copilot.lua, as it
-- provides chat features with the same GitHub Copilot subscription.

return {
  "CopilotC-Nvim/CopilotChat.nvim",
  cond = not Metaconfig.disable_copilot,
  dependencies = {
    "zbirenbaum/copilot.lua",
    "nvim-lua/plenary.nvim",
  },
  keys = {
    { "<leader>cc", function() require("CopilotChat").toggle() end, mode = { "n", "x" }, desc = "[C]hat: toggle" },
    { "<leader>cs", function() require("CopilotChat").stop() end, mode = { "n", "x" }, desc = "[C]hat: [S]top" },
    { "<leader>cr", function() require("CopilotChat").reset() end, mode = { "n", "x" }, desc = "[C]hat: [R]eset" },
    {
      "<leader>cp",
      function() require("CopilotChat").select_prompt() end,
      mode = { "n", "x" },
      desc = "[C]hat: select [P]rompt",
    },
    { "<leader>cm", function() require("CopilotChat").select_model() end, desc = "[C]hat: select [M]odel" },
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
