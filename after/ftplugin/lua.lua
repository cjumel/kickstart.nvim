-- [[ Keymaps ]]

local function yank_item(item)
  if item == nil then
    vim.notify("Nothing to yank", vim.log.levels.WARN)
    return
  end
  vim.fn.setreg('"', item)
  vim.notify('Yanked to register `"`:\n```\n' .. item .. "\n```")
end

vim.keymap.set(
  "n",
  "<leader>ym",
  function() yank_item(require("lang_utils.lua").get_module()) end,
  { buffer = true, desc = "[Y]ank: [M]odule" }
)
vim.keymap.set(
  "n",
  "<leader>yr",
  function() yank_item([[dofile("]] .. vim.fn.expand("%:p:.") .. [[")]]) end,
  { buffer = true, desc = "[Y]ank: [R]EPL command" }
)
