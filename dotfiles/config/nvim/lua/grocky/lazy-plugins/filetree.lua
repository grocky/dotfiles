return {
    'nvim-tree/nvim-tree.lua',
    dependencies = {
        'nvim-tree/nvim-web-devicons',
    },
    config = function()
        require('nvim-tree').setup({
            view = {
                width = 30,
                side = 'left',
            },
            renderer = {
                group_empty = true,
            },
            filters = {
                dotfiles = true,
            },
        })
    end,
    keys = {
        { '<leader>1', function() require("nvim-tree.api").tree.toggle({ find_file = true }) end, desc = 'Toggle file tree' },
    },
}
