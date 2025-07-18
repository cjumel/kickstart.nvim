-- Window
vim.o.showtabline = 1 -- Show tabline only when there are multiple tabs
vim.o.laststatus = 3 -- Global status line for all windows
vim.wo.number = true -- Absolute line numbering
vim.wo.signcolumn = "number" -- Merge sign and number columns together
vim.opt.cursorline = true -- Highlight the cursor line
vim.opt.showmode = false -- Don't show mode in status line (done with lualine.nvim instead)

-- Editor
vim.o.mouse = "a" -- Enable mouse mode in all modes
vim.o.breakindent = true -- After a line wrap, indent the part on the new virtual line
vim.o.winborder = "rounded" -- Use rounded borders for floating windows
vim.o.splitright = true -- Open new vertical split window on the right
vim.o.splitbelow = true -- Open new horizontal split window below
vim.opt.pumheight = 30 -- Maximum number of items to show in the popup menu (e.g. for completion)
vim.o.matchpairs = vim.o.matchpairs .. ",<:>" -- Add recognized character pair

-- Search
vim.o.ignorecase = true -- Case-insensitive searching by default
vim.o.smartcase = true -- Enable case-sensitive searching when "\C" or capital in search
vim.o.hlsearch = true -- Highlight matches during search
vim.opt.shortmess:append("S") -- Remove inline search count during searching (done with lualine.nvim instead)

-- Folding

-- Custom fold text function with Treesitter syntax highlighting and fold ending, taken from
-- https://www.reddit.com/r/neovim/comments/1fzn1zt/custom_fold_text_function_with_treesitter_syntax/
local function fold_virt_text(result, s, lnum, coloff)
  if not coloff then
    coloff = 0
  end
  local text = ""
  local hl
  for i = 1, #s do
    local char = s:sub(i, i)
    local hls = vim.treesitter.get_captures_at_pos(0, lnum, coloff + i - 1)
    local _hl = hls[#hls]
    if _hl then
      local new_hl = "@" .. _hl.capture
      if new_hl ~= hl then
        table.insert(result, { text, hl })
        text = ""
        hl = nil
      end
      text = text .. char
      hl = new_hl
    else
      text = text .. char
    end
  end
  table.insert(result, { text, hl })
end
function _G.custom_foldtext()
  local start = vim.fn.getline(vim.v.foldstart):gsub("\t", string.rep(" ", vim.o.tabstop))
  local end_str = vim.fn.getline(vim.v.foldend)
  local end_ = vim.trim(end_str)
  local result = {}
  fold_virt_text(result, start, vim.v.foldstart - 1)
  table.insert(result, { " ... ", "Delimiter" })
  fold_virt_text(result, end_, vim.v.foldend - 1, #(end_str:match("^(%s+)") or ""))
  return result
end

vim.opt.foldmethod = "expr" -- Define folding method with `foldexpr`
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()" -- Use Treesitter-based folding
vim.opt.foldlevelstart = 99 -- Open buffers with no fold closed
vim.opt.fillchars = { fold = " " } -- Remove dots filling at the end of folded lines
vim.opt.foldtext = "v:lua.custom_foldtext()" -- Custom folded line text

-- Internals
vim.o.undofile = true -- Save undo history to file
vim.o.updatetime = 250 -- Decrease delay for writting swap files
vim.o.timeoutlen = 300 -- Decrease delay between keys in mapped sequences
vim.o.diffopt = "internal,filler,closeoff" -- Remove linematch from diffopt (important for gitsigns.nvim hunk jumps)
vim.o.complete = "" -- Disable builtin auto-completion
vim.o.completeopt = "" -- Remove builtin auto-completion options

-- Diagnostics
vim.diagnostic.config({
  severity_sort = true,
  float = { source = "if_many" },
  signs = {
    text = { -- Set lualine.nvim diagnostic symbols (taken from lualine/components/diagnostics/config.lua)
      [vim.diagnostic.severity.ERROR] = "󰅚 ",
      [vim.diagnostic.severity.WARN] = "󰀪 ",
      [vim.diagnostic.severity.HINT] = "󰌶 ",
      [vim.diagnostic.severity.INFO] = "󰋽 ",
    },
  },
  virtual_text = true,
})

-- Theme-specific options
if ThemeConfig.options_callback then -- Additional theme options setting
  ThemeConfig.options_callback()
end

-- Extra filetypes detection
vim.filetype.add({ filename = MetaConfig.extra_filename_to_filetype })
