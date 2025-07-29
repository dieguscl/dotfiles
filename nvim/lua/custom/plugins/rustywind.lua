-- Make tailwind classes have an specific order
return {
  {
    'peytongraf/rustywind-nvim',
    ft = {
      -- add or remove filetypes in which the plugin should load for as needed
      'javascript',
      'javascriptreact',
      'typescript',
      'typescriptreact',
      'html',
    },
    config = function()
      require('rustywind-nvim').setup {
        -- add the following line to initially disable autoformatting on save
        -- auto_sort_on_save = false
        auto_sort_on_save = true,
      }
    end,
  },
}
