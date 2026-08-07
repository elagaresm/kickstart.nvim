vim.pack.add {
  { src = 'https://github.com/serhez/bento.nvim', version = 'feat/v2' },
}

require('bento').setup {
  ui = {
    floating = {
      minimal_menu = 'dashed',
    },
  },
}

local api = require('bento.api')

-- Register menu keymaps.
-- The expand key and last-buffer key are intentionally the same: press `;`
-- once to expand the menu, `;` again to jump straight to the previous buffer
-- (which auto-collapses back to the dashed overlay).
--
-- We bind `;` directly to `expand_menu` instead of using
-- `register_expand_key` (which maps to `open_menu`, built on `toggle_menu`).
-- `toggle_menu` closes an existing menu window outright, but since
-- `minimal_menu = 'dashed'` keeps a menu window alive at all times, that
-- first press was destroying the persistent dashed overlay instead of
-- expanding it. `expand_menu` only ever expands, never closes, so the
-- overlay is never disabled.
api.register_last_buffer_key ';' -- Label for last-accessed buffer
vim.keymap.set('n', ';', api.expand_menu, { silent = true, desc = 'Bento: expand menu' })
api.register_collapse_key '<Esc>' -- Collapse/close menu
api.register_prev_page_key '[' -- Previous page (pagination)
api.register_next_page_key ']' -- Next page (pagination)

-- bento's persistent dashed overlay is only created once, ~100ms after
-- `setup()` runs (see bento/init.lua). If Neovim starts with no buffers
-- (plain `nvim`), that attempt finds zero valid buffers and bails out with
-- "No buffers to display" -- it never creates the window. Opening buffers
-- afterwards doesn't help either: bento's own `BufAdd`/`BufEnter` autocmds
-- only call `refresh_menu()`, which itself no-ops if the window was never
-- created in the first place.
--
-- So we create it ourselves, once, the first time a real buffer shows up.
-- Two things to avoid:
--   1. Firing on the very first `BufEnter`: Neovim always enters an empty
--      unnamed scratch buffer at startup, which has zero valid marks, so
--      `once = true` here would burn itself out before any real file loads.
--   2. Calling `toggle_menu()` unconditionally on every later `BufEnter`:
--      unlike `expand_menu`, `toggle_menu` CLOSES an existing window, so
--      re-running it after the overlay already exists would toggle it off
--      every time a buffer is entered.
local bento_menu_created = false

local function ensure_bento_menu_created(args)
  if bento_menu_created then
    return
  end

  local name = vim.api.nvim_buf_get_name(args.buf)
  local buftype = vim.api.nvim_get_option_value('buftype', { buf = args.buf })
  if name == '' or (buftype ~= '' and buftype ~= 'terminal') then
    return -- not a real file/terminal buffer yet, keep waiting
  end

  require('bento.ui').toggle_menu()
  bento_menu_created = #require('bento').marks > 0
end

vim.api.nvim_create_autocmd({ 'BufAdd', 'BufEnter' }, {
  callback = ensure_bento_menu_created,
  desc = 'Bento: create the dashed overlay once a real buffer exists',
})

-- Register built-in actions with keymaps and highlights.
api.register_action('open', {
  key = '<CR>',
  action = api.actions.open,
  hl = 'DiagnosticVirtualTextHint',
})
api.register_action('delete', {
  key = '<BS>',
  action = api.actions.delete,
  hl = 'DiagnosticVirtualTextError',
})
api.register_action('vsplit', {
  key = '|',
  action = api.actions.vsplit,
  hl = 'DiagnosticVirtualTextInfo',
})
api.register_action('split', {
  key = '_',
  action = api.actions.split,
  hl = 'DiagnosticVirtualTextInfo',
})
api.register_action('lock', {
  key = '*',
  action = api.actions.lock,
  hl = 'DiagnosticVirtualTextWarn',
})

-- Set default action (used when pressing a label key directly).
api.set_default_action 'open'
