-- Display git signs in `signcolumn`
-- Also provide some git functionality, check docs

return {
    'lewis6991/gitsigns.nvim',
    opts = {
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
    },
    on_attach = function(buf)
      local gitsigns = require('gitsigns')

      local function map(mode, l, r, opts)
        opts = opts or {}
        opts.buffer = buf
        vim.keymap.set(mode, l, r, opts)
      end

      -- Navigation
      map('n', ']c', function()
        if vim.wo.diff then
          vim.cmd.normal({']c', bang = true})
        else
          gitsigns.nav_hunk('next')
        end
      end, { desc = 'Next hunk' })

      map('n', '[c', function()
        if vim.wo.diff then
          vim.cmd.normal({'[c', bang = true})
        else
          gitsigns.nav_hunk('prev')
        end
      end, { desc = 'Prev hunk' })

      -- Actions
      map('n', '<leader>ghs', gitsigns.stage_hunk, { desc = '[G]it [H]unk [S]tage' })
      map('n', '<leader>ghr', gitsigns.reset_hunk, { desc = '[G]it [H]unk [R]eset' })
      map('v', '<leader>ghs', function() gitsigns.stage_hunk {vim.fn.line('.'), vim.fn.line('v')} end, { desc = '[G]it [H]unk [S]tage' })
      map('v', '<leader>ghr', function() gitsigns.reset_hunk {vim.fn.line('.'), vim.fn.line('v')} end, { desc = '[G]it [H]unk [R]eset' })
      map('n', '<leader>gS', gitsigns.stage_buffer, { desc = '[G]it [S]tage buffer' })
      map('n', '<leader>ghu', gitsigns.undo_stage_hunk, { desc = '[G]it [H]unk [U]ndo stage' })
      map('n', '<leader>gR', gitsigns.reset_buffer, { desc = '[G]it [R]eset buffer' })
      map('n', '<leader>ghp', gitsigns.preview_hunk, { desc = '[G]it [H]unk [P]review' })
      map('n', '<leader>gb', function() gitsigns.blame_line{full=true} end, { desc = '[G]it [B]lame line' })
      map('n', '<leader>gtb', gitsigns.toggle_current_line_blame, { desc = '[G]it [T]oggle [B]lame' })
      map('n', '<leader>gd', gitsigns.diffthis, { desc = '[G]it [D]iff buffer' })
      map('n', '<leader>gD', function() gitsigns.diffthis('~') end, { desc = '[G]it [D]iff line' })
      map('n', '<leader>gtd', gitsigns.toggle_deleted, { desc = '[G]it [T]oggle [D]eleted' })

      -- Text object
      map({'o', 'x'}, 'ih', ':<C-U>Gitsigns select_hunk<CR>')

      -- Add keybind helper to `which-key`
      require('which-key').register({
        ['<leader>gt'] = { '[G]it [T]oggle', _ = 'which_key_ignore' },
        ['<leader>gh'] = { '[G]it [H]unk', _ = 'which_key_ignore' },
        ['<leader>g'] = { '[G]it', _ = 'which_key_ignore' },
      })

      require('which-key').register({
        ['<leader>g'] = { '[G]it' },
      }, { mode = 'v' })
      end,
    },
}

