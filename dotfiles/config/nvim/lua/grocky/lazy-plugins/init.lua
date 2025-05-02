return {
    { "nvim-lua/plenary.nvim",                    name = "plenary", },
    "github/copilot.vim",
    { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
    'nvim-tree/nvim-web-devicons',
    {
        'lewis6991/gitsigns.nvim',
        event = "BufReadPre",
        config = function ()
            require('gitsigns').setup({})
        end
    },
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        opts = {
            -- your configuration comes here
            -- or leave it empty to use the default settings
            -- refer to the configuration section below
        },
        keys = {
            {
                "<leader>?",
                function()
                    require("which-key").show({ global = false })
                end,
                desc = "Buffer Local Keymaps (which-key)",
            },
        },
    },
    { 'echasnovski/mini.nvim', version = false },
}
