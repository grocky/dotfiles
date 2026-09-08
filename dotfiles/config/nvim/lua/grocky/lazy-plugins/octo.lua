-- Review pull requests, issues and discussions from inside nvim.
--
-- `bins/ghpr` opens this on a PR: see the review pane in
-- dotfiles/config/tmuxinator/pr-review.yml.

-- Order to try remotes in, shared by `default_remote` and the host sniffing
-- below so both agree on which remote the PR lives on.
local REMOTES = { "origin", "upstream" }

local function github_hostname()
    for _, remote in ipairs(REMOTES) do
        local url = vim.fn.system({ "git", "remote", "get-url", remote })
        if vim.v.shell_error == 0 then
            local host = url:gsub("^%a[%w+.-]*://", "") -- scheme, if any
            host = host:gsub("^[^@/]*@", "")            -- user@, for scp-style urls
            host = host:match "^([^/:%s]+)"             -- up to the port, path or newline
            if host then
                return host ~= "github.com" and host or ""
            end
        end
    end
    return ""
end

return {
    "pwntester/octo.nvim",
    cmd = "Octo",
    opts = function()
        return {
            picker = "telescope",
            -- bare `:Octo` opens a picker of commands
            enable_builtin = true,
            github_hostname = github_hostname(),
            default_remote = REMOTES,
        }
    end,
    keys = {
        {
            "<leader>oi",
            "<CMD>Octo issue list<CR>",
            desc = "List GitHub Issues",
        },
        {
            "<leader>op",
            "<CMD>Octo pr list<CR>",
            desc = "List GitHub PullRequests",
        },
        {
            "<leader>od",
            "<CMD>Octo discussion list<CR>",
            desc = "List GitHub Discussions",
        },
        {
            "<leader>on",
            "<CMD>Octo notification list<CR>",
            desc = "List GitHub Notifications",
        },
        {
            "<leader>os",
            function()
                require("octo.utils").create_base_search_command { include_current_repo = true }
            end,
            desc = "Search GitHub",
        },
    },
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope.nvim",
        "nvim-tree/nvim-web-devicons",
    },
}
