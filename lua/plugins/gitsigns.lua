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
      on_attach = function()
      -- Add keybind helper to `which-key`

      require('which-key').register({
        ['<leader>h'] = { 'Git [H]unk', _ = 'which_key_ignore' },
      })

      require('which-key').register({
        ['<leader>h'] = { 'Git [H]unk' },
      }, { mode = 'v' })
      end,
    },
}

