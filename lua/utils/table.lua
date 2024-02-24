local M = {}

--- Concatenate any number of arrays together.
---@param arrays table<table> An array containing the arrays to concatenate.
---@return table
M.concat_arrays = function(arrays)
  local result = {}

  for _, array in ipairs(arrays) do
    for _, value in ipairs(array) do
      table.insert(result, value)
    end
  end

  return result
end

--- Concatenate any number of dictionaries together.
--- Dictionaries are processed in order, so if some keys are shared, the latest value encountered
--- will take precedence.
---@param dictionaries table<table<string, any>> An array containing the dictionaries to concatenate.
---@return table<string, any>
M.concat_dicts = function(dictionaries)
  local result = {}

  for _, dictionary in ipairs(dictionaries) do
    for key, value in pairs(dictionary) do
      result[key] = value
    end
  end

  return result
end

--- Check if a value is in an array.
---@param value any The value to check for.
---@param array table The array to check in.
---@return boolean
M.is_in_array = function(value, array)
  for _, target_value in ipairs(array) do
    if value == target_value then
      return true
    end
  end

  return false
end

--- Filter out target values from an input array.
---@param array table An array to filter.
---@param targets table The target values to filter out from the array.
---@return table
M.filter_out_array = function(array, targets)
  local result = {}

  for _, value in ipairs(array) do
    if not M.is_in_array(value, targets) then
      table.insert(result, value)
    end
  end

  return result
end

return M
