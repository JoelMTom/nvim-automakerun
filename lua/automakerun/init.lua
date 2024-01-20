local float_window = require("automakerun.ui.float-window")

local Amr ={}

Amr.__index = Amr

function Amr.new()
  local self = setmetatable({
    tasks_filename = nil,
    build_filename = nil,
    build_window = nil,
    run_window = float_window.new("run"),
    default_tasks_json = nil,
  }, Amr)

  return self
end

function Amr:setup(opts)
  self.default_tasks_json  = opts.default_json
  self.tasks_filename = opts.tasks_filename
  self.build_filename =  opts.build_filename
  self.build_window = float_window.new(self.build_filename)
  -- self.run_window = float_window.new("run")
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

return Amr.new()
