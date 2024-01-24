local utils = require("automakerun.utils")

--@class AmrConfig
--@field filename string | nil
--@field default_tasks table | nil
--@field tasks table | nil
--@field buffer number | nil

local AmrConfig = {}

AmrConfig.__index = AmrConfig

--@param filename string
--@param default_tasks table
--@return AmrConfig
function AmrConfig.new(filename, default_tasks)
  local self = setmetatable({
    filename = filename,
    default_tasks = default_tasks,
    buffer = nil,
    tasks = nil,
  }, AmrConfig)
  return self
end

--@return buffer
function AmrConfig:openfile()
  local buffer = vim.fn.bufadd(self.filename)
  vim.fn.bufload(buffer)
  self.buffer = buffer
  return buffer
end

function AmrConfig:write_file()
  local lines = vim.json.encode(self.tasks)
  vim.api.nvim_buf_set_lines(self.buffer, 0, -1, false, {lines})
  vim.api.nvim_buf_call(self.buffer, function ()
    vim.api.nvim_cmd({
      cmd = "write",
      args = { self.filename }
    }, { output = false })
  end)
end

--@return tasks
function AmrConfig:readfile()
  if self.buffer == nil then
    self:openfile()
  end
  local lines = vim.api.nvim_buf_get_lines(self.buffer, 0, -1, false)

  if #lines == 1 and lines[1] == ""  then
    self.tasks = self.default_tasks
    self:write_file()
    return self.tasks
  end
  local data = utils.concateStrings(lines, "")
  self.tasks = vim.json.decode(data)
  return self.tasks
end

function AmrConfig:enable()
  self.tasks = nil
  self:readfile()
end

return AmrConfig.new()
