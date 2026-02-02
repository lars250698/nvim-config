return {
  { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    lazy = false,
    priority = 50,
    build = ':TSUpdate',
    main = 'nvim-treesitter.configs', -- Sets main module to use for opts
    opts = {
      ensure_installed = { 'bash', 'c', 'diff', 'html', 'lua', 'luadoc', 'markdown', 'markdown_inline', 'query', 'vim', 'vimdoc' },
      auto_install = true,
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = { 'ruby' },
      },
      indent = { enable = true, disable = { 'ruby' } },
    },
  },
  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    lazy = false,
    config = function()
      require('nvim-treesitter-textobjects').setup {
        select = { lookahead = true },
        move = { set_jumps = true },
      }

      local select = require 'nvim-treesitter-textobjects.select'
      local move = require 'nvim-treesitter-textobjects.move'
      local swap = require 'nvim-treesitter-textobjects.swap'

      -- Select textobjects
      local sel_maps = {
        { 'af', '@function.outer', 'around function' },
        { 'if', '@function.inner', 'inner function' },
        { 'ac', '@class.outer', 'around class' },
        { 'ic', '@class.inner', 'inner class' },
        { 'aa', '@parameter.outer', 'around argument' },
        { 'ia', '@parameter.inner', 'inner argument' },
      }
      for _, m in ipairs(sel_maps) do
        vim.keymap.set({ 'x', 'o' }, m[1], function()
          select.select_textobject(m[2], 'textobjects')
        end, { desc = m[3] })
      end

      -- Move between textobjects
      local move_maps = {
        { ']f', 'goto_next_start', '@function.outer', 'Next function start' },
        { ']F', 'goto_next_end', '@function.outer', 'Next function end' },
        { '[f', 'goto_previous_start', '@function.outer', 'Prev function start' },
        { '[F', 'goto_previous_end', '@function.outer', 'Prev function end' },
        { ']c', 'goto_next_start', '@class.outer', 'Next class start' },
        { ']C', 'goto_next_end', '@class.outer', 'Next class end' },
        { '[c', 'goto_previous_start', '@class.outer', 'Prev class start' },
        { '[C', 'goto_previous_end', '@class.outer', 'Prev class end' },
        { ']a', 'goto_next_start', '@parameter.inner', 'Next argument' },
        { '[a', 'goto_previous_start', '@parameter.inner', 'Prev argument' },
      }
      for _, m in ipairs(move_maps) do
        vim.keymap.set({ 'n', 'x', 'o' }, m[1], function()
          move[m[2]](m[3], 'textobjects')
        end, { desc = m[4] })
      end

      -- Swap arguments
      vim.keymap.set('n', '<leader>a', function()
        swap.swap_next '@parameter.inner'
      end, { desc = 'Swap with next argument' })
      vim.keymap.set('n', '<leader>A', function()
        swap.swap_previous '@parameter.inner'
      end, { desc = 'Swap with prev argument' })
    end,
  },
}
