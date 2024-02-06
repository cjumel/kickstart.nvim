local M = {}

-- Concatenate any number of arrays together.
---@param arrays table An array of arrays.
M.concat_arrays = function(arrays)
  local result = {}

  for _, array in ipairs(arrays) do
    for _, value in ipairs(array) do
      table.insert(result, value)
    end
  end

  return result
end

-- Concatenate any number of dictionaries together. Dictionaries are processed in order, so if
-- some keys are shared, the latest value encountered will take precedence.
---@param dictionaries table An array of dictionaries.
M.concat_dicts = function(dictionaries)
  local result = {}

  for _, dictionary in ipairs(dictionaries) do
    for key, value in pairs(dictionary) do
      result[key] = value
    end
  end

  return result
end

return M
