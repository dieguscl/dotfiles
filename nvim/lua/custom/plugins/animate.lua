-- animate cursor transitions so I don't lose myself
return {
  'echasnovski/mini.animate',
  config = function()
    local animate = require('mini.animate')
    local mouse_scrolling = false

    animate.setup {
      cursor = {
        enable = true,
        timing = animate.gen_timing.linear { duration = 80, unit = 'total' },
      },
      scroll = {
        enable = true,
        timing = animate.gen_timing.linear { duration = 80, unit = 'total' },
        subscroll = animate.gen_subscroll.equal {
          predicate = function(total_scroll)
            if mouse_scrolling then return false end
            return total_scroll > 1
          end,
        },
      },
      resize = { enable = false },
      open = { enable = false },
      close = { enable = false },
    }

    -- Bypass scroll animation for mouse/trackpad
    for _, key in ipairs { '<ScrollWheelUp>', '<ScrollWheelDown>' } do
      vim.keymap.set({ 'n', 'i', 'v' }, key, function()
        mouse_scrolling = true
        vim.schedule(function() mouse_scrolling = false end)
        return key
      end, { expr = true })
    end
  end,
}
