-- Set <space> as the leader key
vim.g.mapleader = ' '
vim.g.mapcallleader = ' '

-- Enable spell checker
vim.opt.spell = true
vim.opt.spelllang = 'en_us'

-- Enable NerdFont icons and symbols
vim.g.have_nerd_font = true

-- Show line number
vim.opt.number = true

-- Show sign column
vim.opt.signcolumn = 'yes'

-- Enable saving of undo history
vim.opt.undofile = true

-- Enable break indent
vim.opt.breakindent = true

-- Set search to case-insensitive by default
-- Switches to the case-sensitive if capital letter or \C
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Decrease update time, popups shown faster
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300

-- Custom display for some whitespace characters
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Show which line the cursor is on
vim.opt.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor
vim.opt.scrolloff = 12

-- Clear highlight of search on <Esc> in normal mode
vim.opt.hlsearch = true
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous [D]iagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next [D]iagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic [E]rror messages' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Highlight on yank
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking',
  group = vim.api.nvim_create_augroup('yank-highlight', { clear = true }),
  callback = function ()
    vim.highlight.on_yank()
  end,
})

local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
  'tpope/vim-sleuth', -- Auto detection of shiftwidth

  { -- Comments toggle with `gcc`
    'terrortylor/nvim-comment',
    config = function()
      require('nvim_comment').setup()
    end
  },

  { -- Highlight `TODO` and `NOTE` in comments
    'folke/todo-comments.nvim',
    event = 'VimEnter',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = { signs = false },
  },

  { -- Helper, shows current keybinds
    'folke/which-key.nvim',
    event = 'VimEnter',
    config = function()
      require('which-key').setup()
    end,
  },

  -- Import plugins: `lua/plugins/*.lua`
  { import = 'plugins' }
})

