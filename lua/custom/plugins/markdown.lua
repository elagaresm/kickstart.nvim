-- markdown-preview.nvim ships a node app that must be installed after the plugin is fetched.
vim.api.nvim_create_autocmd('PackChanged', {
  callback = function(ev)
    if ev.data.spec.name ~= 'markdown-preview.nvim' then return end
    if ev.data.kind ~= 'install' and ev.data.kind ~= 'update' then return end

    local result = vim.system({ 'npx', '--yes', 'yarn', 'install' }, { cwd = vim.fs.joinpath(ev.data.path, 'app') }):wait()
    if result.code ~= 0 then vim.notify('Build failed for markdown-preview.nvim:\n' .. (result.stderr or ''), vim.log.levels.ERROR) end
  end,
})

vim.pack.add {
  'https://github.com/iamcco/markdown-preview.nvim',
  'https://github.com/OXY2DEV/markview.nvim',
}

-- Renders markdown in the buffer. Raw text is shown on the cursor line only while in insert mode.
require('markview').setup {
  preview = {
    filetypes = { 'markdown' },
    modes = { 'n', 'no', 'c', 'i' },
    hybrid_modes = { 'i' },
    linewise_hybrid_mode = true,
  },
}

-- <leader>m* is taken by minuet (see ai.lua), so use <leader>p, but only in markdown buffers.
vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('markdown-preview-keymap', { clear = true }),
  pattern = 'markdown',
  callback = function(args)
    -- markview falls back to raw pipes for tables in wrapped windows.
    vim.opt_local.wrap = false
    vim.keymap.set('n', '<leader>p', '<cmd>MarkdownPreviewToggle<cr>', { buffer = args.buf, desc = 'Toggle markdown [P]review' })
    vim.keymap.set('n', '<leader>P', '<cmd>Markview toggle<cr>', { buffer = args.buf, desc = 'Toggle in-buffer markdown [P]review' })
  end,
})
