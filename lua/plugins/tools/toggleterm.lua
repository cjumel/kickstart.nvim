-- toggleterm.nvim
--
-- toggleterm.nvim is a Neovim plugin to persist and interact with multiple terminals during an editing session. It
-- provides several improvements over the builtin terminal integration, which make it a really nice addition to Neovim,
-- while remaining quite simple to use and to configure.

return {
  "akinsho/toggleterm.nvim",
  keys = function()
    local actions = require("plugins.tools.toggleterm.actions")
    return {
      { "<leader>tt", actions.toggle, desc = "[T]erminal: toggle" },
      { "<leader>ta", actions.toggle_all, desc = "[T]erminal: toggle [A]ll" },
      { "<leader>tn", actions.new_terminal, desc = "[T]erminal: [N]ew terminal" },
      { "<leader>tv", actions.new_terminal_in_vertical_split, desc = "[T]erminal: new terminal in [V]ertical split" },
      { "<leader>tc", actions.change_name, desc = "[T]erminal: [C]hange name" },
      { "<leader>ts", actions.send_line, desc = "[T]erminal: [S]end line" },
      { "<leader>tr", actions.run_file_in_repl, ft = { "lua", "python" }, desc = "[T]erminal: [R]un file in REPL" },
      { "<leader>t", actions.send_selection, mode = "v", desc = "[T]erminal: send selection" },
    }
  end,
  opts = {
    size = function(term) -- Define relative size for horizontal and vertical splits
      if term.direction == "horizontal" then
        return vim.o.lines * 0.25
      elseif term.direction == "vertical" then
        return vim.o.columns * 0.4
      end
    end,
  },
}
