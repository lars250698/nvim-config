return {
  {
    'folke/persistence.nvim',
    event = 'BufReadPre',
    cmd = { 'SessionRestore', 'SessionSelect', 'SessionRestoreLast', 'SessionStop' },
    opts = {},
    keys = {},
    config = function()
      require('persistence').setup {}
      local cmd = require 'config.commands'
      cmd.create('SessionRestore', function() require('persistence').load() end, { desc = 'Restore Session' })
      cmd.create('SessionSelect', function() require('persistence').select() end, { desc = 'Select Session' })
      cmd.create('SessionRestoreLast', function() require('persistence').load { last = true } end, { desc = 'Restore Last Session' })
      cmd.create('SessionStop', function() require('persistence').stop() end, { desc = 'Stop saving current session' })
      cmd.create('SessionStart', function() require('persistence').start() end, { desc = 'Start saving current session' })
    end,
  },
}
