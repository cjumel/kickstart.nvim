-- Telescope.nvim
--
-- Gaze deeply into unknwn regions of your code with powerful and blazing fast fuzzy finding
-- tools.

return {
  "nvim-telescope/telescope.nvim",
  branch = "0.1.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons",
    "folke/trouble.nvim",
    -- Fuzzy Finder Algorithm which requires local dependencies to be built.
    -- Only load if `make` is available. Make sure you have the system
    -- requirements installed.
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      -- NOTE: If you are having trouble with this installation,
      --       refer to the README for telescope-fzf-native for more instructions.
      build = "make",
      cond = function()
        return vim.fn.executable("make") == 1
      end,
    },
  },
  lazy = true,
  init = function()
    vim.keymap.set("n", "<leader><space>", function()
      require("telescope.builtin").buffers()
    end, { desc = "[ ] Find: buffers" })

    vim.keymap.set("n", "<leader>/", function()
      require("telescope.builtin").current_buffer_fuzzy_find(
        require("telescope.themes").get_dropdown({
          winblend = 10,
          previewer = false,
        })
      )
    end, { desc = "[/] Find: fuzzily in buffer" })

    local nmap = function(keys, func, desc)
      if desc then
        desc = "[F]ind: " .. desc
      end
      vim.keymap.set("n", keys, func, { desc = desc })
    end

    nmap("<leader>fr", function()
      require("telescope.builtin").resume()
    end, "[R]esume")

    -- Find files by file name
    nmap("<leader>ff", function()
      require("telescope.builtin").find_files({
        find_command = { "rg", "--files", "--hidden" },
      })
    end, "[F]iles")
    nmap("<leader>fa", function()
      require("telescope.builtin").find_files({
        find_command = { "rg", "--files", "--hidden" },
        follow = true,
        no_ignore = true,
      })
    end, "[A]ll files")
    nmap("<leader>fo", function()
      require("telescope.builtin").oldfiles()
    end, "[O]ld files")

    -- Find files by file content
    nmap("<leader>fg", function()
      require("telescope.builtin").live_grep()
    end, "by [G]rep")
    nmap("<leader>fw", function()
      require("telescope.builtin").grep_string()
    end, "[W]ord under the cursor")

    -- Git-related find commands
    nmap("<leader>fs", function()
      require("telescope.builtin").git_status()
    end, "git [S]tatus")
    nmap("<leader>fb", function()
      require("telescope.builtin").git_branches()
    end, "git [B]ranches")
    nmap("<leader>fcm", function()
      require("telescope.builtin").git_commits()
    end, "git [C]o[M]mits")
    nmap("<leader>fS", function()
      require("telescope.builtin").git_stash()
    end, "git [S]tash")

    -- Neovim-related find commands
    nmap("<leader>fk", function()
      require("telescope.builtin").keymaps()
    end, "[K]eymaps")
    nmap("<leader>fcu", function()
      require("telescope.builtin").commands()
    end, "[C]ommand [U]sage")
    nmap("<leader>fch", function()
      require("telescope.builtin").command_history()
    end, "[C]ommand [H]istory")
    nmap("<leader>fh", function()
      require("telescope.builtin").help_tags()
    end, "[H]elp")
    nmap("<leader>fcs", function()
      require("telescope.builtin").colorscheme()
    end, "[C]olor [S]cheme")
  end,
  config = function()
    local actions = require("telescope.actions")
    local trouble = require("trouble.providers.telescope")
    require("telescope").setup({
      defaults = {
        n = {
          ["="] = actions.select_default,
          ["<c-t>"] = trouble.open_with_trouble,
        },
        mappings = {
          i = {
            ["<c-t>"] = trouble.open_with_trouble,
          },
        },
        -- vimgrep_arguments is used for live_grep and grep_string
        vimgrep_arguments = {
          "rg",
          "--color=never", -- must not be removed
          "--no-heading", -- must not be removed
          "--with-filename", -- must not be removed
          "--line-number", -- must not be removed
          "--column", -- must not be removed
          "--smart-case",
          "--hidden",
        },
        file_ignore_patterns = {
          ".git/",
        },
      },
    })

    -- Enable telescope fzf native, if installed
    pcall(require("telescope").load_extension, "fzf")
  end,
}
