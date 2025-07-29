-- Have a tree with the undo history, great for not losing work
return {
  'mbbill/undotree',
  config = function()
    vim.api.nvim_set_keymap('n', '<leader>u', ':UndotreeToggle<CR>', { noremap = true, silent = true })
  end,
}
