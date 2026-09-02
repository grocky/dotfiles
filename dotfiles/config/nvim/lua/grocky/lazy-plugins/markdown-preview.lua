return {
    "iamcco/markdown-preview.nvim",
    ft = "markdown",
    cmd = { "MarkdownPreview", "MarkdownPreviewStop", "MarkdownPreviewToggle" },
    build = "cd app && yarn install",
    keys = {
        {
            "<leader>mp",
            "<cmd>MarkdownPreviewToggle<CR>",
            ft = "markdown",
            desc = "Toggle markdown preview",
        },
    },
    init = function ()
        vim.g.mkdp_filetypes = { "markdown" }
        vim.g.mkdp_echo_preview_url = 1
    end
}
