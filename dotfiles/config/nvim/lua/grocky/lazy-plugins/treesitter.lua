return {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    config = function()
        local parsers = {
            "arduino",
            "bash",
            "blade",
            "cpp",
            "css",
            "dockerfile",
            "go",
            "hcl",
            "html",
            "javascript",
            "jsdoc",
            "lua",
            "markdown",
            "markdown_inline",
            "make",
            "php",
            "templ",
            "typescript",
            "vim",
            "vimdoc",
            "yaml",
        }

        if vim.fn.executable("tree-sitter") == 1 then
            require("nvim-treesitter").install(parsers)
        else
            vim.schedule(function()
                vim.notify(
                    "nvim-treesitter: parser install skipped because 'tree-sitter' CLI is missing.\nInstall it with `npm i -g tree-sitter-cli` (or your package manager), then run :TSUpdate.",
                    vim.log.levels.WARN
                )
            end)
        end

        vim.api.nvim_create_autocmd("FileType", {
            group = vim.api.nvim_create_augroup("grocky.treesitter", {}),
            callback = function(args)
                local lang = vim.treesitter.language.get_lang(vim.bo[args.buf].filetype)
                if lang and vim.treesitter.language.add(lang) then
                    vim.treesitter.start(args.buf)
                    vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
                end
            end,
        })
    end,
}
