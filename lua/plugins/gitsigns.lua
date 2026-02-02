-- Adds git related signs to the gutter, as well as utilities for managing changes
-- NOTE: gitsigns is already included in init.lua but contains only the base
-- config. This will add also the recommended keymaps.

return {
  {
    'lewis6991/gitsigns.nvim',
    init = function()
      local cmd = require 'config.commands'

      cmd.create('GitStageHunk', function(o)
        if o.range == 2 then
          require('gitsigns').stage_hunk { o.line1, o.line2 }
        else
          require('gitsigns').stage_hunk()
        end
      end, { range = true, desc = 'Git stage hunk' })

      cmd.create('GitResetHunk', function(o)
        if o.range == 2 then
          require('gitsigns').reset_hunk { o.line1, o.line2 }
        else
          require('gitsigns').reset_hunk()
        end
      end, { range = true, desc = 'Git reset hunk' })

      cmd.create('GitStageBuffer', function() require('gitsigns').stage_buffer() end, { desc = 'Git stage buffer' })
      cmd.create('GitUndoStage', function() require('gitsigns').undo_stage_hunk() end, { desc = 'Git undo stage hunk' })
      cmd.create('GitResetBuffer', function() require('gitsigns').reset_buffer() end, { desc = 'Git reset buffer' })
      cmd.create('GitPreviewHunk', function() require('gitsigns').preview_hunk() end, { desc = 'Git preview hunk' })
      cmd.create('GitBlame', function() require('gitsigns').blame_line() end, { desc = 'Git blame line' })
      cmd.create('GitDiff', function() require('gitsigns').diffthis() end, { desc = 'Git diff against index' })
      cmd.create('GitDiffLast', function() require('gitsigns').diffthis '@' end, { desc = 'Git diff against last commit' })
      cmd.create('GitToggleBlame', function() require('gitsigns').toggle_current_line_blame() end, { desc = 'Toggle git blame' })
      cmd.create('GitToggleDeleted', function() require('gitsigns').preview_hunk_inline() end, { desc = 'Toggle git deleted' })
    end,
    opts = {
      on_attach = function(bufnr)
        local gitsigns = require 'gitsigns'

        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation (bracket jumps)
        map('n', ']h', function()
          if vim.wo.diff then
            vim.cmd.normal { ']c', bang = true }
          else
            gitsigns.nav_hunk 'next'
          end
        end, { desc = 'Jump to next git [c]hange' })

        map('n', '[h', function()
          if vim.wo.diff then
            vim.cmd.normal { '[c', bang = true }
          else
            gitsigns.nav_hunk 'prev'
          end
        end, { desc = 'Jump to previous git [c]hange' })
      end,
    },
  },
}
