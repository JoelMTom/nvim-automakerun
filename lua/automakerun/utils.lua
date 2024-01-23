local M = {}

function M.concateStrings(strings, delim)
  local res = ""
  for _, value in pairs(strings) do
    res = res .. value .. delim
  end
  return res
end

return M
