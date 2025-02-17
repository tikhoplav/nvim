-- Plugin to automatically close html tags
-- Make sure 'nvim-treesitter' is installed 

return {
  'windwp/nvim-ts-autotag',
  config = function()
    require('nvim-ts-autotag').setup({
      opts = {
        enable_close = true,
        enable_rename = true,
        enable_close_on_slash = true,
      },
    })
  end,
}
