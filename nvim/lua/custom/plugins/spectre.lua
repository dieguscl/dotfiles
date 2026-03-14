return {
  'nvim-pack/nvim-spectre',
  dependencies = { 'nvim-lua/plenary.nvim' },
  keys = {
    { '<leader>S', function() require('spectre').toggle() end, desc = '[S]earch & Replace (Spectre)' },
    { '<leader>S', function() require('spectre').open_visual { select_word = true } end, mode = 'v', desc = '[S]earch & Replace selection' },
  },
}
