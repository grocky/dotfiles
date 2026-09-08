-- Review pull requests, issues and discussions from inside nvim.
--
-- Octo shells out to `gh`, so it picks up the host from the repo's git remote
-- and works against GitHub Enterprise without extra configuration -- there is a
-- `github_hostname` option, but setting it would pin every repo to one host.
--
-- `bins/ghpr` opens this on a PR: see the editor pane in
-- dotfiles/config/tmuxinator/pr-review.yml.
return {
    "pwntester/octo.nvim",
    cmd = "Octo",
    opts = {
        picker = "telescope",
        -- bare `:Octo` opens a picker of commands
        enable_builtin = true,
        -- Octo ships { "upstream", "origin" }, which suits the fork workflow
        -- where the PR lives on the canonical repo rather than your fork. Ours
        -- is the other way round: this repo keeps the enterprise remote on
        -- `origin` and a github.com mirror on `upstream`, and gh is only
        -- authenticated to the enterprise host, so trying `upstream` first sends
        -- every query to github.com and fails. Preferring `origin` also matches
        -- `bins/ghpr`, which fetches the PR from `origin` by default.
        default_remote = { "origin", "upstream" },
    },
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
