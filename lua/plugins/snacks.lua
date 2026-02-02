return {
  {
    'folke/snacks.nvim',
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
      bigfile = { enabled = true },
      indent = { enabled = true },
      quickfile = { enabled = true },
      words = { enabled = true },
      scroll = {
        animate = {
          duration = { step = 15, total = 250 },
          easing = 'linear',
        },
        -- faster animation when repeating scroll after delay
        animate_repeat = {
          delay = 100, -- delay in ms before using the repeat animation
          duration = { step = 5, total = 50 },
          easing = 'linear',
        },
        -- what buffers to animate
        filter = function(buf)
          return vim.g.snacks_scroll ~= false and vim.b[buf].snacks_scroll ~= false and vim.bo[buf].buftype ~= 'terminal'
        end,
      },
      picker = {
        win = {
          input = {
            keys = {
              ['<Esc>'] = { 'close', mode = { 'n', 'i' } },
            },
          },
        },
      },
      input = { enabled = true },
      notifier = { enabled = true },
      scope = { enabled = true },
    },
    keys = {
      {
        '<leader>/',
        function()
          Snacks.picker.grep()
        end,
        desc = '[/] Grep',
      },
      {
        '<leader><space>',
        function()
          Snacks.picker.files()
        end,
        desc = 'Find Files',
      },
      {
        '<leader>,',
        function ()
          Snacks.picker.buffers()
        end,
        desc = 'Find Buffers'
      },
      {
        '<leader>:',
        function ()
          Snacks.picker.commands()
        end,
        desc = 'Find Commands'
      }
    },
    config = function(_, opts)
      local snacks = require 'snacks'
      snacks.setup(opts)

      local cmd = require 'config.commands'
      cmd.create('BufDelete', function() snacks.bufdelete() end, { abbrev = 'bdd', desc = 'Delete Buffer' })
      cmd.create('BufOnly', function() snacks.bufdelete.other() end, { abbrev = 'bdo', desc = 'Delete all Buffers except Current' })
      cmd.create('PickQuickfix', function() snacks.picker.qflist() end, { abbrev = 'pqf', desc = 'Quickfix list' })
      cmd.create('PickDiagnostics', function() snacks.picker.diagnostics() end, { abbrev = 'diag', desc = 'Diagnostics list' })
      cmd.create('SearchHistory', function() snacks.picker.search_history() end, { abbrev = 'she', desc = 'Search history' })
      cmd.create('PickTreesitter', function() snacks.picker.treesitter() end, { abbrev = 'pts', desc = 'Treesitter picker' })
      cmd.create('Recent', function() snacks.picker.recent() end, { abbrev = 'rec', desc = 'Recent files' })
    end,
  },
}
