vim.keymap.set("n", "<leader>ab", function ()
  require("automakerun"):build()
end, {
  silent = true,
  noremap = true,
  desc = "run make command"
})

vim.keymap.set("n", "<leader>ar", function ()
  require("automakerun"):run()
end, {
  silent = true,
  noremap = true,
  desc = "run make command"
})

vim.keymap.set("n", "<leader>ae", function ()
  require("automakerun"):exit()
end, {
  silent = true,
  noremap = true,
  desc = "run make command"
})

vim.keymap.set("n", "<leader>at", function ()
  require("automakerun"):toggle()
end, {
  silent = true,
  noremap = true,
  desc = "toggle build window"
})
