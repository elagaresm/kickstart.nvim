if true then
  return
end

vim.pack.add {
  'https://github.com/milanglacier/minuet-ai.nvim',
}

require('minuet').setup {
  duet = {
    provider = 'gemini',
    provider_options = {
      gemini = {
        model = 'gemini-3-flash-preview',
        optional = {
          generationConfig = {
            thinkingConfig = {
              -- Disable thinking is recommended
              thinkingLevel = 'minimal',
            },
          },
        },
      },
    },
  },
  provider = 'gemini',
  provider_options = {
    gemini = {
      model = 'gemini-3.5-flash-lite',
      -- system = 'see [Prompt] section for the default value',
      -- few_shots = 'see [Prompt] section for the default value',
      -- chat_input = 'See [Prompt Section for default value]',
      stream = true,
      api_key = 'GEMINI_API_KEY',
      end_point = 'https://generativelanguage.googleapis.com/v1beta/models',
      optional = {
        -- recommended to prevent request timeout from outputting too many tokens
        generationConfig = {
          maxOutputTokens = 256,
          thinkingConfig = {
            -- disable thinking for 3.x models
            thinkingLevel = 'minimal',
          },
        },
      },
      -- a list of functions to transform the endpoint, header, and request body
      transform = {},
    },
  },
  virtualtext = {
    -- Disabled by default, use <leader>mt to toggle auto-trigger per buffer.
    auto_trigger_ft = {},
    keymap = {
      accept = '<C-l>',
      accept_line = '<C-j>',
      dismiss = '<C-c>',
      prev = '<C-p>',
      next = '<C-n>',
    },
  },
}

vim.keymap.set('n', '<leader>mt', '<cmd>Minuet virtualtext toggle<cr>', { desc = 'Minuet virtualtext toggle' })
vim.keymap.set('n', '<leader>mp', '<cmd>Minuet duet predict<cr>', { desc = 'Minuet duet predict' })
vim.keymap.set('n', '<leader>ma', '<cmd>Minuet duet apply<cr>', { desc = 'Minuet duet apply' })
vim.keymap.set('n', '<leader>md', '<cmd>Minuet duet dismiss<cr>', { desc = 'Minuet duet dismiss' })
vim.keymap.set('i', '<A-z>', '<cmd>Minuet duet predict<cr>', { desc = 'Minuet duet predict' })
vim.keymap.set('i', '<A-a>', '<cmd>Minuet duet apply<cr>', { desc = 'Minuet duet apply' })
vim.keymap.set('i', '<A-x>', '<cmd>Minuet duet dismiss<cr>', { desc = 'Minuet duet dismiss' })
