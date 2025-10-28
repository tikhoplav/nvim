-- Language Server Protocol
-- Uses dockerized versions of LSP servers

return {
  'neovim/nvim-lspconfig',
  dependencies = {
    -- Show load status in bottom right corner
    { 'j-hui/fidget.nvim', opts = {} },
  },
  config = function()
    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
      callback = function(event)
        local map = function(keys, func, desc)
          vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
        end

        map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
        map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
        map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
        map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinitions')
        map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
        map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
        map('<leader>rn', vim.lsp.buf.rename, '[R]e[N]ame')
        map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
        map('K', vim.lsp.buf.hover, 'Hover Documentation')
        map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

        require('which-key').add({
          { '<leader>c', desc = '[C]ode' },
          { '<leader>d', desc = '[D]ocument' },
          { '<leader>w', desc = '[W]orkspace' },
          { '<leader>r', desc = '[R]ename' },
          { 'g', desc = '[G]oto' },
        })

        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if client and client.server_capabilities.documentHighlightProvider then
          local highlight_augroup = vim.api.nvim_create_augroup('lsp-highlight', { clear = false })

          vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
            buffer = event.buf,
            group = highlight_augroup,
            callback = vim.lsp.buf.document_highlight,
          })

          vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
            buffer = event.buf,
            group = highlight_augroup,
            callback = vim.lsp.buf.clear_references,
          })

          vim.api.nvim_create_autocmd('LspDetach', {
            group = vim.api.nvim_create_augroup('lsp-detach', { clear = true }),
            callback = function(event2)
              vim.lsp.buf.clear_references()
              vim.api.nvim_clear_autocmds({
                group = 'lsp-highlight',
                buffer = event2.buf,
              })
            end,
          })
        end
      end,
    })

    -- local root_dir = vim.fn.getcwd()
    -- local capabilities = vim.lsp.protocol.make_client_capabilities()
    -- capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())
    --
    -- require('lspconfig').clangd.setup({
    --   cmd = { 'clangd' },
    --   capabilities = capabilities,
    -- })
    --
    -- -- require('lspconfig').zls.setup({
    -- --   cmd = { 'docker', 'run', '-i', '--rm', 'tikhoplav/zls' },
    -- --   filetypes = { 'zig', 'zir' },
    -- --   capabilities = capabilities,
    -- --   settings = {
    -- --     zls = {
    -- --       semantic_tokens = "partial",
    -- --     },
    -- --   },
    -- -- })
    --
    -- vim.api.nvim_create_autocmd('BufWritePre', {
    --   pattern = { "*.zig", "*.zon" },
    --   callback = function(ev)
    --     vim.lsp.buf.format()
    --     vim.lsp.buf.code_action({
    --       context = { only = { "source.fixAll" }},
    --       apply = true,
    --     })
    --     vim.lsp.buf.code_action({
    --       context = { only = { "source.organizeImports" }},
    --       apply = true,
    --     })
    --   end
    -- })
    --
    -- require('lspconfig').zls.setup({
    --   cmd = { 'zls' },
    --   settings = {
    --     zls = {
    --       enable_build_on_save = true,
    --       semantic_tokens = "partial",
    --     }
    --   }
    -- })
    --
    -- require('lspconfig').lua_ls.setup({
    --   cmd = { 'docker', 'run', '-i', '--rm', 'tikhoplav/lua-language-server' },
    --   capabilities = capabilities,
    -- })
    --
    -- -- require('lspconfig').rust_analyzer.setup({
    -- --   before_init = function(params)
    -- --     params.processId = vim.NIL
    -- --   end,
    -- --   cmd = { 'docker', 'run', '-i', '--rm', '-v', root_dir .. ':' .. root_dir .. ':z', 'tikhoplav/rust-language-server' },
    -- --   root_dir = function(fname)
    -- --     local util = require('lspconfig').util
    -- --
    -- --     return util.root_pattern('Cargo.toml')(fname)
    -- --       or util.find_git_ancestor(fname)
    -- --   end,
    -- --   capabilities = capabilities,
    -- -- })
    --
    -- require('lspconfig').vtsls.setup({
    --   before_init = function(params)
    --     params.processId = vim.NIL
    --   end,
    --   cmd = { 'docker', 'run', '-i', '--rm', '-v', root_dir .. ':' .. root_dir .. ':z', 'tikhoplav/vtsls-language-server' },
    --   filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue' },
    --   settings = {
    --     vtsls = {
    --       autoUseWorkspaceTsdk = true,
    --       tsserver = {
    --         globalPlugins = {
    --           {
    --             name = '@vue/typescript-plugin',
    --             location = '/usr/local/lib/node_modules/@vue/language-server',
    --             languages = { 'vue' },
    --             configNamespace = "typescript",
    --             enableForWorkspaceTypeScriptVersions = true,
    --           },
    --         },
    --       },
    --     },
    --   },
    --   capabilities = capabilities,
    -- })
    --
    -- require('lspconfig').wgsl_analyzer.setup({
    --   cmd = { 'docker', 'run', '-i', '--rm', 'tikhoplav/wgsl-language-server' },
    --   capabilities = capabilities,
    -- })
    --
    -- require('lspconfig').solidity.setup({
    --   before_init = function(params)
    --     params.processId = vim.NIL
    --   end,
    --   cmd = { 'docker', 'run', '-i', '--rm', '-v', root_dir .. ':' .. root_dir .. ':z', 'tikhoplav/solidity-language-server' },
    --   capabilities = capabilities,
    -- })
  end,
}

