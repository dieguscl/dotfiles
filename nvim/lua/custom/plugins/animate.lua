-- animate cursor transitions so I don't lose myself
return {
  'echasnovski/mini.animate',
  config = function()
    require('mini.animate').setup()
  end,
  -- TODO: find how to modify the timing to make it faster
  --
  --   require('mini.animate').setup {
  --     -- Cursor path
  --     cursor = {
  --       enable = true,
  --       timing = function()
  --         return 100
  --       end,
  --     },
  --
  --     -- Vertical scroll
  --     scroll = {
  --       enable = true,
  --       timing = function()
  --         return 100
  --       end,
  --     },
  --
  --     -- Window resize
  --     resize = {
  --       -- Whether to enable this animation
  --       enable = true,
  --       timing = function()
  --         return 100
  --       end,
  --     },
  --     open = {
  --       enable = true,
  --       timing = function()
  --         return 100
  --       end,
  --     },
  --
  --     -- Window close
  --     close = {
  --       enable = true,
  --       timing = function()
  --         return 'linear', 100
  --       end,
  --     },
  --   }
  -- end,
}
