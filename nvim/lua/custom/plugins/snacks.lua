---@type table<number, {token:lsp.ProgressToken, msg:string, done:boolean}[]>
local progress = vim.defaulttable()
vim.api.nvim_create_autocmd('LspProgress', {
  ---@param ev {data: {client_id: integer, params: lsp.ProgressParams}}
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    local value = ev.data.params.value --[[@as {percentage?: number, title?: string, message?: string, kind: "begin" | "report" | "end"}]]
    if not client or type(value) ~= 'table' then
      return
    end
    local p = progress[client.id]

    for i = 1, #p + 1 do
      if i == #p + 1 or p[i].token == ev.data.params.token then
        p[i] = {
          token = ev.data.params.token,
          msg = ('[%3d%%] %s%s'):format(
            value.kind == 'end' and 100 or value.percentage or 100,
            value.title or '',
            value.message and (' **%s**'):format(value.message) or ''
          ),
          done = value.kind == 'end',
        }
        break
      end
    end

    local msg = {} ---@type string[]
    progress[client.id] = vim.tbl_filter(function(v)
      return table.insert(msg, v.msg) or not v.done
    end, p)

    local spinner = { '⠋', '⠙', '⠹', '⠸', '⠼', '⠴', '⠦', '⠧', '⠇', '⠏' }
    vim.notify(table.concat(msg, '\n'), vim.log.levels.INFO, {
      id = 'lsp_progress',
      title = client.name,
      opts = function(notif)
        notif.icon = #progress[client.id] == 0 and ' ' or spinner[math.floor(vim.uv.hrtime() / (1e6 * 80)) % #spinner + 1]
      end,
    })
  end,
})

return {
  'folke/snacks.nvim',
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  opts = {
    -- bigfile = { enabled = true },
    gitbrowse = { enabled = true },
    notifier = {
      enabled = true,
      timeout = 5000,
      border = 'rounded',
    },
    dashboard = {
      enabled = true,
      sections = {
        { section = 'header' },
        {
          pane = 2,
          section = 'terminal',
          cmd = '/home/transpara/shell-color-scripts/colorscript.sh -e square',
          height = 5,
          padding = 1,
        },
        { section = 'keys', gap = 1, padding = 1 },
        -- {
        --   pane = 2,
        --   icon = ' ',
        --   desc = 'Browse Repo',
        --   padding = 1,
        --   key = 'b',
        --   action = function()
        --     Snacks.gitbrowse()
        --   end,
        -- },
        function()
          local in_git = Snacks.git.get_root() ~= nil
          local cmds = {
            {
              icon = ' ',
              title = 'Git Status',
              cmd = 'hub --no-pager diff --stat -B -M -C',
              height = 10,
            },
            {
              title = 'Open Issues',
              cmd = 'gh issue list -L 3',
              -- key = 'i',
              -- action = function()
              --   vim.fn.jobstart('gh issue list --web', { detach = true })
              -- end,
              icon = ' ',
              height = 7,
            },
            {
              icon = ' ',
              title = 'Open PRs',
              cmd = 'gh pr list -L 3',
              -- key = 'p',
              -- action = function()
              --   vim.fn.jobstart('gh pr list --web', { detach = true })
              -- end,
              height = 7,
            },
            {
              title = 'Notifications',
              cmd = 'gh notify -s -a -n5',
              -- action = function()
              --   vim.ui.open 'https://github.com/notifications'
              -- end,
              -- key = 'n',
              -- icon = ' ',
              height = 5,
              enabled = true,
            },
          }
          return vim.tbl_map(function(cmd)
            return vim.tbl_extend('force', {
              pane = 2,
              section = 'terminal',
              enabled = in_git,
              padding = 1,
              ttl = 5 * 60,
              indent = 3,
            }, cmd)
          end, cmds)
        end,
        { section = 'startup' },
      },
    },

    -- quickfile = { enabled = true },
    -- statuscolumn = { enabled = true },
    -- words = { enabled = true },
    -- styles = {
    --   notification = {
    --     wo = { wrap = true } -- Wrap notifications
    --   }
    -- }
  },
  keys = {
    -- { "<leader>.",  function() Snacks.scratch() end, desc = "Toggle Scratch Buffer" },
    -- { "<leader>S",  function() Snacks.scratch.select() end, desc = "Select Scratch Buffer" },
    {
      '<leader>n',
      function()
        Snacks.notifier.show_history()
      end,
      desc = 'Notification History',
    },
    -- { "<leader>bd", function() Snacks.bufdelete() end, desc = "Delete Buffer" },
    -- { "<leader>cR", function() Snacks.rename.rename_file() end, desc = "Rename File" },
    -- { "<leader>gB", function() Snacks.gitbrowse() end, desc = "Git Browse" },
    -- { "<leader>gb", function() Snacks.git.blame_line() end, desc = "Git Blame Line" },
    -- { "<leader>gf", function() Snacks.lazygit.log_file() end, desc = "Lazygit Current File History" },
    -- { "<leader>gg", function() Snacks.lazygit() end, desc = "Lazygit" },
    -- { "<leader>gl", function() Snacks.lazygit.log() end, desc = "Lazygit Log (cwd)" },
    -- { "<leader>un", function() Snacks.notifier.hide() end, desc = "Dismiss All Notifications" },
    -- { "<c-/>",      function() Snacks.terminal() end, desc = "Toggle Terminal" },
    -- { "<c-_>",      function() Snacks.terminal() end, desc = "which_key_ignore" },
    -- { "]]",         function() Snacks.words.jump(vim.v.count1) end, desc = "Next Reference", mode = { "n", "t" }
  },
  --   { "[[",         function() Snacks.words.jump(-vim.v.count1) end, desc = "Prev Reference", mode = { "n", "t" } },
  --   {
  --     "<leader>N",
  --     desc = "Neovim News",
  --     function()
  --       Snacks.win({
  --         file = vim.api.nvim_get_runtime_file("doc/news.txt", false)[1],
  --         width = 0.6,
  --         height = 0.6,
  --         wo = {
  --           spell = false,
  --           wrap = false,
  --           signcolumn = "yes",
  --           statuscolumn = " ",
  --           conceallevel = 3,
  --         },
  --       })
  --     end,
  --   }
  -- },
  -- init = function()
  --   vim.api.nvim_create_autocmd("User", {
  --     pattern = "VeryLazy",
  --     callback = function()
  --       -- Setup some globals for debugging (lazy-loaded)
  --       _G.dd = function(...)
  --         Snacks.debug.inspect(...)
  --       end
  --       _G.bt = function()
  --         Snacks.debug.backtrace()
  --       end
  --       vim.print = _G.dd -- Override print to use snacks for `:=` command
  --
  --       -- Create some toggle mappings
  --       Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
  --       Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
  --       Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
  --       Snacks.toggle.diagnostics():map("<leader>ud")
  --       Snacks.toggle.line_number():map("<leader>ul")
  --       Snacks.toggle.option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 }):map("<leader>uc")
  --       Snacks.toggle.treesitter():map("<leader>uT")
  --       Snacks.toggle.option("background", { off = "light", on = "dark", name = "Dark Background" }):map("<leader>ub")
  --       Snacks.toggle.inlay_hints():map("<leader>uh")
  --     end,
  --   })
  -- end,
}
