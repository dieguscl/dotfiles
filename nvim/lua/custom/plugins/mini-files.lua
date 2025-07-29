return { {
  'echasnovski/mini.files',
  version = '*',
  dependencies = { 'echasnovski/mini.icons' },
  config = function()
    require('mini.files').setup()
  end,
} }
