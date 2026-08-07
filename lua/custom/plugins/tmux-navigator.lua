vim.pack.add {
  'https://github.com/christoomey/vim-tmux-navigator',
}

-- Seamlessly navigate between Neovim splits and tmux panes with CTRL+<hjkl>.
vim.keymap.set('n', '<C-h>', '<cmd>TmuxNavigateLeft<cr>', { desc = 'Navigate to the left window/pane' })
vim.keymap.set('n', '<C-j>', '<cmd>TmuxNavigateDown<cr>', { desc = 'Navigate to the lower window/pane' })
vim.keymap.set('n', '<C-k>', '<cmd>TmuxNavigateUp<cr>', { desc = 'Navigate to the upper window/pane' })
vim.keymap.set('n', '<C-l>', '<cmd>TmuxNavigateRight<cr>', { desc = 'Navigate to the right window/pane' })
vim.keymap.set('n', '<C-\\>', '<cmd>TmuxNavigatePrevious<cr>', { desc = 'Navigate to the previous window/pane' })
