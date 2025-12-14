local function get_package_name()
    local bufnr = vim.api.nvim_get_current_buf()
    local filetype = vim.bo[bufnr].filetype

    if filetype == "go" then
        local ok, parser = pcall(vim.treesitter.get_parser, bufnr, "go")
        if not ok or not parser then
            return ""
        end
        local tree = parser:parse()[1]
        if tree then
            local root = tree:root()
            -- Navigate directly: package_clause is a top-level child
            for child in root:iter_children() do
                if child:type() == "package_clause" then
                    local pkg_id = child:named_child(0)
                    if pkg_id and pkg_id:type() == "package_identifier" then
                        return vim.treesitter.get_node_text(pkg_id, bufnr)
                    end
                end
            end
        end
        -- Fallback: determine from directory name if not found in file
        local filename = vim.api.nvim_buf_get_name(bufnr)
        if filename ~= "" then
            return vim.fn.fnamemodify(vim.fn.expand(filename), ":p:h:t")
        end
    end
    return ""
end

local function is_supported_language()
    local bufnr = vim.api.nvim_get_current_buf()
    local filetype = vim.bo[bufnr].filetype
    return filetype == "go"
end

return {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons', opt = true },
    config = function()
        require('lualine').setup({
            options = {
                icons_enabled = true,
                theme = 'auto',
                component_separators = { left = '', right = '' },
                section_separators = { left = '', right = '' },
                disabled_filetypes = {
                    statusline = {},
                    winbar = {},
                },
                ignore_focus = {},
                always_divide_middle = true,
                always_show_tabline = true,
                globalstatus = false,
                refresh = {
                    statusline = 100,
                    tabline = 100,
                    winbar = 100,
                }
            },
            sections = {
                lualine_a = { 'mode' },
                lualine_b = { 'branch', 'diff', 'diagnostics' },
                lualine_c = {
                    { get_package_name, is_supported_language },
                    'filename',
                },
                lualine_x = { 'encoding', 'fileformat', 'filetype' },
                lualine_y = { 'progress' },
                lualine_z = { 'location' }
            },
            inactive_sections = {
                lualine_a = {},
                lualine_b = {},
                lualine_c = {
                    { get_package_name, is_supported_language },
                    'filename',
                },
                lualine_x = { 'location' },
                lualine_y = {},
                lualine_z = {}
            },
            tabline = {},
            winbar = {},
            inactive_winbar = {},
            extensions = {}
        })
    end
}
