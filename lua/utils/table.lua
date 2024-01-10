local M = {}

-- Concatenate two arrays.
M.concat_arrays = function(table_1, table_2)
  local result = {}

  for _, value in ipairs(table_1) do
    table.insert(result, value)
  end
  for _, value in ipairs(table_2) do
    table.insert(result, value)
  end

  return result
end

-- Concatenate two dictionaries. If some keys are in common, table_1's values will take precedence.
M.concat_dicts = function(table_1, table_2)
  local result = {}

  -- Let's do table_2 first so that table_1's values overwrites table_2 if some keys are in common
  for k, v in pairs(table_2) do
    result[k] = v
  end
  for k, v in pairs(table_1) do
    result[k] = v
  end

  return result
end

return M
