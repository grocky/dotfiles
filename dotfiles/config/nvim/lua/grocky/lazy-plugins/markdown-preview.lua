local function on_wsl()
    return (vim.env.WSL_DISTRO_NAME ~= nil)
end

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

        if on_wsl() then
            vim.cmd([[
                function! GrockyOpenInWindowsBrowser(url)
                    " explorer.exe exits 1 even when it succeeds, so we need to ignore the exit code
                    call jobstart(['explorer.exe', a:url], {'detach': v:true})
                endfunction
            ]])
            vim.g.mkdp_browserfunc = "GrockyOpenInWindowsBrowser"
        end
    end,
}
