vim.pack.add {
  'https://github.com/stevearc/oil.nvim',
}

require('oil').setup {
  view_options = { show_hidden = true },
}

vim.keymap.set('n', '<leader>e', require('oil').toggle_float, { desc = 'Toggle Oil [E]xplorer' })

vim.keymap.set('n', '-', '<cmd>Oil<cr>', { desc = 'Toggle Oil Explorer' })
