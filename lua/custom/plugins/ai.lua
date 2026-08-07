if true then
  return
end

vim.pack.add {
  'https://github.com/milanglacier/minuet-ai.nvim',
}

require('minuet').setup {
  provider = 'claude',
  provider_options = {
    claude = {
      max_tokens = 256,
      model = 'claude-haiku-4-5',
      -- system = 'see [Prompt] section for the default value',
      -- few_shots = 'see [Prompt] section for the default value',
      -- chat_input = 'See [Prompt Section for default value]',
      stream = true,
      api_key = 'ANTHROPIC_API_KEY',
      end_point = 'https://api.anthropic.com/v1/messages',
      optional = {
        -- pass any additional parameters you want to send to claude request,
        -- e.g.
        -- stop_sequences = nil,
      },
      -- a list of functions to transform the endpoint, header, and request body
      transform = {},
    },
  },
  virtualtext = {
    -- Automatically show ghost text suggestions in every filetype, so we can
    -- verify the API call works without depending on any keymap.
    auto_trigger_ft = { '*' },
    keymap = {
      accept = '<C-l>',
      accept_line = '<C-j>',
      dismiss = '<C-c>',
    },
  },
}
