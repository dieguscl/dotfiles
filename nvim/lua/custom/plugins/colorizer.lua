return {
  {
    'norcalli/nvim-colorizer.lua',
    config = function()
      require('colorizer').setup {
        '*', -- Enable colorizer for all file types
        css = { css = true }, -- Enable CSS color properties
        html = { names = true }, -- Enable named colors in HTML
      }
    end,
  },
}
