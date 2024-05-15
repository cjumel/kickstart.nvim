-- Set conceal level to hide some information in the buffer; default to 0 (no concealment)
if not vim.g.disable_concealing then
  vim.opt_local.conceallevel = 2 -- Hide concealable text almost all the time
end
