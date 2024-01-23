local floatWindow = require("automakerun.ui.floatWindow")
local AmrConfig = require("automakerun.config.AmrConfig")

local Amr ={}

Amr.__index = Amr

function Amr.new()
  local self = setmetatable({
    enabled = false,
    tasksFilename = nil,
    buildFilename = nil,
    amrDir = nil,
    buildWindow = nil,
    runWindow = floatWindow.new("run"),
    defaultTasks = nil,
    AmrConfig = nil
  }, Amr)

  return self
end

function Amr:setup(opts)
  print("a")
  self.defaultTasks = opts.defaultTasks
  self.amrDir = vim.fs.normalize(opts.amrDir, {})
  self.tasksFilename = self.amrDir .. "/" .. vim.fs.normalize(opts.tasksFilename, {})
  self.buildFilename =  self.amrDir .. "/" .. vim.fs.normalize(opts.buildFilename, {})
  self.buildWindow = floatWindow.new(self.buildFilename)
  self.AmrConfig = AmrConfig.new(self.tasksFilename, self.defaultTasks)
end

function Amr:enable()
  if vim.fn.isdirectory(self.amrDir) ~= 1 then
    vim.fn.mkdir(self.amrDir, "p")
  end
  self.AmrConfig:readfile()
  self.enabled = true
end

function Amr:build()
  if not self.enabled then
    return
  end
  self.buildWindow:runCmd("clang++", { "main.cpp", "-o main" }, true)
end

function Amr:run()
  if not self.enabled then
    return
  end
  self.runWindow:runCmd("./main", {}, false)
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
