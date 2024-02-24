local M = {}

--- Convert a regular text with white spaces and hyphens to a single camelcase word.
---@param text string The text to convert.
---@return string
M.text_to_camelcase = function(text)
  -- Split the text into sub-words using spaces and hyphens as separators
  local sub_words = {}
  for word in text:gmatch("%S+") do
    for sub_word in word:gmatch("[^-]+") do
      table.insert(sub_words, sub_word)
    end
  end

  -- Capitalize the first letter of each word
  for i = 1, #sub_words do
    sub_words[i] = sub_words[i]:sub(1, 1):upper() .. sub_words[i]:sub(2)
  end

  -- Concatenate the words together
  return table.concat(sub_words)
end

return M
