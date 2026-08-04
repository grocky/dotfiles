-- Where am I? The statusline answers with a trail: which repository, which
-- package, which file. The repository half matters most when reading code that
-- is not yours -- following a definition into a dependency drops you in a tree
-- with no other sign of whose it is, or which version of it you are reading.

local M = {}

local function unescape(name)
    return (name:gsub("!(%a)", string.upper))
end

-- module_cache_repo names a dependency read out of the Go module cache.
--
-- The module directory is the one carrying a version, which is also the
-- boundary that matters: a repository can publish several modules, and
-- golang.org/x/tools and .../tools/gopls version independently of each other.
local function module_cache_repo(path)
    local rest = path:match("/pkg/mod/(.+)$")
    if not rest then
        return nil
    end
    for segment in vim.gsplit(rest, "/") do
        if segment:find("@", 1, true) then
            return unescape(segment)
        end
    end
    return nil
end

-- vendor_repo names a dependency vendored into the tree.
--
-- Vendor directories record no module boundary, so this reads the layout: a
-- host, then an owner, then the repository. Hosts that skip the owner --
-- gopkg.in/yaml.v2 -- stop a segment short.
local function vendor_repo(path)
    local rest = path:match("/vendor/(.+)$")
    if not rest then
        return nil
    end

    local segments = vim.split(vim.fs.dirname("/" .. rest), "/", { trimempty = true })
    if #segments == 0 then
        return nil
    end
    if #segments >= 3 and segments[1]:find(".", 1, true) then
        return segments[3]
    end
    return segments[math.min(2, #segments)]
end

-- git_repo names the working tree a file belongs to. The marker may be a 
-- directory or, in a worktree or submodule, a file.
local function git_repo(path)
    local marker = vim.fs.find(".git", { upward = true, path = vim.fs.dirname(path) })[1]
    if not marker then
        return nil
    end
    return vim.fs.basename(vim.fs.dirname(marker))
end

-- goroot is resolved once per session and remembered, including the failure.
--
-- It is worked out from the go binary on PATH rather than asking `go env`:
-- this runs while the statusline is being drawn, where starting a process is
-- both far too slow and, in a fast event context, not allowed at all. Only
-- libuv calls are used here for the same reason.
local goroot

local function looks_like_goroot(dir)
    local stat = vim.uv.fs_stat(dir .. "/src/runtime")
    return stat ~= nil and stat.type == "directory"
end

local function find_goroot()
    if vim.env.GOROOT and vim.env.GOROOT ~= "" then
        return vim.env.GOROOT
    end

    for dir in vim.gslpit(vim.env.PATH or "", ":", {trimempty = true }) do
        local candidate = dir .. "/go"
        if vim.uv.fs_stat(candidate) then
            local real = vim.uv.fs_realpath(candidate)
            if real then
                local root = vim.fs.dirname(vim.fs.dirname(real))
                if looks_like_goroot(root) then
                    return root
                end
            end
        end
    end
    return nil
end

local function get_goroot()
    if goroot == nil then
        goroot = find_goroot() or false
    end
    return goroot or nil
end

-- goroot_src is where the standard library's sources really live. Distributions
-- package them apart from the toolchain. Debian puts GOROOT at /usr/lib/go-<version>
-- and symlinks its src at /usr/share/go-<version>. Neovim names a buffer by the path
-- it resolves to, so the symlink has to be followed to recognise the file as stdlib at all.
local goroot_src

local function get_goroot_src()
    if goroot_src == nil then
        local root = get_goroot()
        goroot_src = root and vim.uv.fs_realpath(root .. "/src") or false
    end
    return goroot_src or nil
end

-- goroot_repo names the standard library. Which toolchain it cam from is the same question as which
-- version of a module you are in, so the directory Go was installed as is the answer.
-- "go", or "go-1.26" where it is versioned.
local function goroot_repo(path)
    local root = get_goroot()
    if not root then
        return nil
    end
    local src = get_goroot_src()
    if vim.startswith(path, root .. "/") or (src and vim.startswith(path, src .. "/")) then
        return vim.fs.basename(root)
    end
    return nil
end

-- repo names the checkout, module, or toolchain a file belongs to.
--
-- The cheap and certain answers come first. Walking up for a .git marker touches the filesystem,
-- and asking for GOROOT starts a process, so neither runs until the path itself has failed to say.
function M.repo(path)
    if not path or path == "" then
        return nil
    end
    return module_cache_repo(path)
        or vendor_repo(path)
        or git_repo(path)
        or goroot_repo(path)
end

-- package_name returns the Go package name of a buffer, or nil if it is not a Go file.
-- TODO: make this generic to other languagees that have packages/modules.
function M.package_name(bufnr)
    if vim.bo[bufnr].filetype ~= "go" then
        return nil
    end

    local ok, parser = pcall(vim.treesitter.get_parser, bufnr, "go")
    if not ok or not parser then
        return nil
    end

    local tree = parser:parse()[1]
    if not tree then
        return nil
    end

    -- the package clause is a top-level child, so there is no need to walk.
    for child in tree:root():iter_children() do
        if child:type() == "package_clause" then
            local pkg = child:named_child(0)
            if pkg and pkg:type() == "package_identifier" then
                return vim.treesitter.get_node_text(pkg, bufnr)
            end
        end
    end
    return nil
end

-- sections builds labels for one buffer.
local function sections(bufnr)
    local path = vim.api.nvim_buf_get_name(bufnr)
    if path == "" or vim.bo[bufnr].buftype ~= "" then
        return { repo = "", package = "" }
    end

    local repo = M.repo(path)

    -- A Go file names its own package. Anything else gets the directory it sits in, unlabelled:
    -- a folder is not a package and should not claim to be.
    local pkg = M.package_name(bufnr)
    if pkg then
        pkg = "pkg " .. pkg
    else
        pkg = vim.fs.basename(vim.fs.dirname(path))
    end

    return { repo = repo and ("repo " .. repo) or "", package = pkg }
end

-- Resolving costs a filesystem walk and syntax tree, and the statusline redraws several times a
-- second, so each buffer's answer is worked out once. It is thrown away when the buffer is written.
-- The package clause is the one part that can change under unchanged name, or rename.
local cache = {}

local function current(bufnr)
    local path = vim.api.nvim_buf_get_name(bufnr)
    local entry = cache[bufnr]
    if entry and entry.path == path then
        return entry.value
    end

    local value = sections(bufnr)
    cache[bufnr] = { path = path, value = value }
    return value
end

-- The two halves are statusline components in their own right rather than one joined string,
-- so the separators between them are the ones lualine is configured to draw, and a section with
-- nothing to say simply does not appear.
function M.repo_section()
    local buf = vim.api.nvim_get_current_buf()
    return current(buf).repo
end

function M.package_section()
    local buf = vim.api.nvim_get_current_buf()
    return current(buf).package
end

function M.invalidate(bufnr)
    if bufnr then
        cache[bufnr] = nil
    else
        cache = {}
    end
end

local group = vim.api.nvim_create_augroup("GrockyBreadcrumb", { clear = true })
vim.api.nvim_create_autocmd({ "BufWritePost", "BufFilePost", "FileType" }, {
    group = group,
    callback = function(args)
        M.invalidate(args.buf)
    end,
})
vim.api.nvim_create_autocmd({ "BufDelete", "BufWipeout" }, {
    group = group,
    callback = function(args)
        M.invalidate(args.buf)
    end,
})

return M
