return {
  body = "<leader>h",
  config = {
    desc = "[H]unk menu",
    color = "pink", -- Allow other keymaps while the Hydra is open (e.g. move cursor and select lines to stage)
  },
  mode = { "n", "v" },
  heads = {
    -- Don't use Neovim arrow keys ("h", "j", "k", "l") or visual mode keys ("v" & "V") to be able to select lines and
    -- stage or discard them
    { "p", function() require("gitsigns").preview_hunk() end },
    {
      "s",
      function()
        if vim.fn.mode() == "n" then
          require("gitsigns").stage_hunk()
        else
          require("gitsigns").stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end
      end,
    },
    {
      "t",
      function()
        vim.g.gitsigns_all_hunk_navigation = not vim.g.gitsigns_all_hunk_navigation
        if vim.g.gitsigns_all_hunk_navigation then
          vim.notify("All hunk navigation enabled", vim.log.levels.INFO)
        else
          vim.notify("All hunk navigation disabled", vim.log.levels.INFO)
        end
      end,
    },
    {
      "x",
      function()
        if vim.fn.mode() == "n" then
          require("gitsigns").reset_hunk()
        else
          require("gitsigns").reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end
      end,
    },
    {
      ",",
      function()
        require("gitsigns").nav_hunk(
          ---@diagnostic disable-next-line: param-type-mismatch
          "next",
          { target = vim.g.gitsigns_all_hunk_navigation and "all" or nil }
        )
      end,
    },
    {
      ";",
      function()
        require("gitsigns").nav_hunk(
          ---@diagnostic disable-next-line: param-type-mismatch
          "prev",
          { target = vim.g.gitsigns_all_hunk_navigation and "all" or nil }
        )
      end,
    },
    { "<Esc>", nil, { exit = true, mode = "n", desc = false } },
  },
  hint = [[
                                             Hunk
   _p_ ➜ [P]review hunk                  _t_ ➜ [T]oggle all hunk navigation   _,_ ➜ Next hunk   
   _s_ ➜ Toggle [S]tage hunk/selection   _x_ ➜ Discard hunk/selection         _;_ ➜ Previous hunk   
     
]],
}
