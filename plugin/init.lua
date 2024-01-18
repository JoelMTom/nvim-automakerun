-- vim.api.nvim_set_keymap("n", "<leader>ac", ':lua require("automakerun")', opts?)

vim.api.nvim_set_keymap("n", "<leader>ao", ":lua require('automakerun').open()<CR>", { silent = true, noremap = true, desc = "open test"})
vim.api.nvim_set_keymap("n", "<leader>ac", ":lua require('automakerun').close()<CR>", { silent = true, noremap = true, desc = "close test"})
