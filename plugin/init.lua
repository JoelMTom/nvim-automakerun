vim.keymap.set("n", "<leader>aa", function ()
  require("automakerun"):enable()
end, {
  silent = true,
  noremap = true,
  desc = "Enable Amr"
})

vim.keymap.set("n", "<leader>ab", function ()
  require("automakerun"):build()
end, {
  silent = true,
  noremap = true,
  desc = "Run build command"
})

vim.keymap.set("n", "<leader>ar", function ()
  require("automakerun"):run()
end, {
  silent = true,
  noremap = true,
  desc = "Run the project"
})

vim.keymap.set("n", "<leader>ae", function ()
  require("automakerun"):exit()
end, {
  silent = true,
  noremap = true,
  desc = "Exit the run window"
})

vim.keymap.set("n", "<leader>at", function ()
  require("automakerun"):toggle()
end, {
  silent = true,
  noremap = true,
  desc = "Toggle build window"
})

--[[ vim.keymap.set("n", "<leader>as", function ()
  require("automakerun"):configRead()
end, {
  silent = true,
  noremap = true,
  desc = "Setup config"
}) ]]
