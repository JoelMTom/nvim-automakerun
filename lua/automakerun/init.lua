local floatWindow = require("automakerun.ui.floatWindow")
local AmrConfig = require("automakerun.config.AmrConfig")

--@class Amr
--@field enabled boolean
--@field tasksFilename string
--@field build string 
--@field amrDir string
--@field buildWindow floatWindow
--@field runWindow floatWindow
--@field defaultTasks table
--@field amrConfig AmrConfig

local Amr ={}

Amr.__index = Amr

--@require Amr
function Amr.new()
  local self = setmetatable({
    enabled = false,
    tasksFilename = nil,
    buildFilename = nil,
    amrDir = nil,
    buildWindow = nil,
    runWindow = floatWindow.new("run"),
    defaultTasks = nil,
    amrConfig = nil
  }, Amr)

  return self
end

--@param opts table
function Amr:setup(opts)
  self.defaultTasks = opts.defaultTasks
  self.amrDir = vim.fs.normalize(opts.amrDir, {})
  self.tasksFilename = self.amrDir .. "/" .. vim.fs.normalize(opts.tasksFilename, {})
  self.buildFilename =  self.amrDir .. "/" .. vim.fs.normalize(opts.buildFilename, {})
  self.buildWindow = floatWindow.new(self.buildFilename)
  self.amrConfig = AmrConfig.new(self.tasksFilename, self.defaultTasks)
end

function Amr:enable()
  if vim.fn.isdirectory(self.amrDir) ~= 1 then
    vim.fn.mkdir(self.amrDir, "p")
  end
  self.amrConfig:enable()
  vim.api.nvim_create_autocmd("BufWritePost", {
    pattern = { self.tasksFilename },
    group = vim.api.nvim_create_augroup("AmrConfigWrite", { clear = true }),
    callback = function (_)
      self.amrConfig:enable()
    end
  })
  self.enabled = true
end


function Amr:build()
  if not self.enabled then
    return
  end
---@diagnostic disable-next-line: undefined-field
  local buildConf = self.amrConfig.tasks.build
  local cmd = buildConf.cmd
  local args = buildConf.args
  self.buildWindow:runCmd(cmd, args, true)
  -- print(vim.inspect(cmd), vim.inspect(args))
  -- print(vim.inspect(self.amrConfig.tasks.build))
end

function Amr:run()
  if not self.enabled then
    return
  end
---@diagnostic disable-next-line: undefined-field
  local runConf = self.amrConfig.tasks.run
  local cmd = runConf.cmd
  local args = runConf.args
  self.runWindow:runCmd(cmd, args, false)
end

function Amr:exit()
  if not self.enabled then
    return
  end
  self.runWindow:close()
end

function Amr:toggle()
  if not self.enabled then
    return
  end
  self.runWindow:close()
  self.buildWindow:toggle()
end

--[[ function Amr:configRead()
  if not self.enabled then
    return
  end
  self.AmrConfig:openfile()
  self.AmrConfig:readfile()
end ]]

return Amr.new()
