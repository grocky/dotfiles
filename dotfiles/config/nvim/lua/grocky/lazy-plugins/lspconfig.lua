vim.lsp.config('lua_ls', {
    settings = {
        Lua = {
            diagnostics = {
                globals = { 'vim', 'require' },
            },
            workspace = {
                library = vim.api.nvim_get_runtime_file("", true),
                checkThirdParty = false,
            },
        },
    },
})
vim.lsp.config('css_variables', {
    filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "css", "scss", "less" },
})

vim.lsp.config('intelephense', {
    filetypes = { 'php', 'blade' },
    capabilities = {
        workspace = {
            didChangeWatchedFiles = { dynamicRegistration = false },
        },
    },
    settings = {
        intelephense = {
            files = {
                maxSize = 1000000,
                exclude = {
                    "**/.git/**",
                    "**/.svn/**",
                    "**/.hg/**",
                    "**/CVS/**",
                    "**/.DS_Store/**",
                    "**/node_modules/**",
                    "**/bower_components/**",
                    "**/vendor/**/{Tests,tests}/**",
                    "**/.history/**",
                    "**/vendor/**/vendor/**",
                    "**/data/**",
                },
            },
        },
    }
})

return {
    "nvim/nvim-lspconfig",
    dependencies = {
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
        "hrsh7th/nvim-cmp",
        "j-hui/fidget.nvim",
        "onsails/lspkind.nvim",
    },

    config = function()
        local cmp = require('cmp')
        local cmp_lsp = require("cmp_nvim_lsp")
        local capabilities = vim.tbl_deep_extend(
            "force",
            vim.lsp.protocol.make_client_capabilities(),
            cmp_lsp.default_capabilities())

        vim.lsp.config('*', { capabilities = capabilities })

        require("fidget").setup({})

        local cmp_select = { behavior = cmp.SelectBehavior.Select }

        cmp.setup({
            mapping = cmp.mapping.preset.insert({
                ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
                ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
                ['('] = cmp.mapping.select_prev_item(cmp_select),
                [')'] = cmp.mapping.select_next_item(cmp_select),
                ['<CR>'] = cmp.mapping.confirm({ select = true }),
                ['<C-t>'] = cmp.mapping.complete(),
            }),
            sources = {
                { name = 'nvim_lsp' },
                { name = 'buffer' },
            },
            formatting = {
                fields = {'abbr', 'kind', 'menu'},
                format = require('lspkind').cmp_format({
                    mode = 'symbol',
                    maxwidth = 50,
                    ellipsis_char = '...',
                })
            },
        })

        vim.diagnostic.config({
            -- update_in_insert = true,
            float = {
                focusable = false,
                style = "minimal",
                border = "rounded",
                source = "always",
                header = "",
                prefix = "",
            },
        })
    end
}
