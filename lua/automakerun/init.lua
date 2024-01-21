local float_window = require("automakerun.ui.float-window")
local config = require("automakerun.config.config")

local Amr ={}

Amr.__index = Amr

function Amr.new()
  local self = setmetatable({
    tasks_filename = nil,
    build_filename = nil,
    amr_dir = nil,
    build_window = nil,
    run_window = float_window.new("run"),
    default_tasks = nil,
    configuration = nil
  }, Amr)

  return self
end

function Amr:setup(opts)
  self.default_tasks = opts.default_tasks
  self.amr_dir = vim.fs.normalize(opts.amr_dir, {})
  self.tasks_filename = self.amr_dir .. "/" .. vim.fs.normalize(opts.tasks_filename, {})
  self.build_filename =  self.amr_dir .. "/" .. vim.fs.normalize(opts.build_filename, {})
  self.build_window = float_window.new(self.build_filename)
  self.configuration = config.new(self.tasks_filename, self.default_tasks)

  if vim.fn.isdirectory(self.amr_dir) ~= 1 then
    vim.fn.mkdir(self.amr_dir, "p")
  end

end

function Amr:build()
  self.build_window:run_cmd("clang++", { "main.cpp", "-o main" }, true)
end

function Amr:run()
  self.run_window:run_cmd("./main", {}, false)
end

function Amr:exit()
  self.run_window:close()
end

function Amr:toggle()
  self.run_window:close()
  self.build_window:toggle()
end

function Amr:config_read()
  self.configuration:openfile()
  self.configuration:readfile()
end

return Amr.new()
