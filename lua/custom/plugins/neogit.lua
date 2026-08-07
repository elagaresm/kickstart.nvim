vim.pack.add {
	'https://github.com/NeogitOrg/neogit',
}

vim.keymap.set('n', '<leader>gg', '<cmd>Neogit<cr>', { desc = "Show Neo[g]it UI"})
