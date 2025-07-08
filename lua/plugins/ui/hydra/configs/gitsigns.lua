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
        vim.g._gitsigns_all_hunk_navigation = not vim.g._gitsigns_all_hunk_navigation
        if vim.g._gitsigns_all_hunk_navigation then
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
        if vim.g._gitsigns_all_hunk_navigation == nil or not vim.g._gitsigns_all_hunk_navigation then
          require("gitsigns").nav_hunk("next")
        else
          require("gitsigns").nav_hunk("next", { target = "all" })
        end
      end,
    },
    {
      ";",
      function()
        if vim.g._gitsigns_all_hunk_navigation == nil or not vim.g._gitsigns_all_hunk_navigation then
          require("gitsigns").nav_hunk("prev")
        else
          require("gitsigns").nav_hunk("prev", { target = "all" })
        end
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
