require("grocky.remap")
require("grocky.set")

require("grocky.lazy")

local augroup = vim.api.nvim_create_augroup
local grockyGroup = augroup('grocky', {})

local autocmd = vim.api.nvim_create_autocmd

function R(name)
    require("plenary.reload").reload_module(name)
end

vim.filetype.add({
    extension = {
        templ = 'templ',
    }
})

function Map(mode, lhs, rhs, opts)
    local options = { noremap = true, silent = true }
    if opts then
        options = vim.tbl_extend("force", options, opts)
    end
    vim.keymap.set(mode, lhs, rhs, options)
end

local function lsp_keymap_opts(e, desc)
    return { buffer = e.buf, desc = desc }
end

autocmd('LspAttach', {
    group = grockyGroup,
    callback = function(e)
        Map("n", "gd", vim.lsp.buf.definition, lsp_keymap_opts(e, "go to definition"))
        Map("n", "gi", vim.lsp.buf.implementation, lsp_keymap_opts(e, "go to implementation"))
        Map("n", "K", vim.lsp.buf.hover, lsp_keymap_opts(e, "show documentation"))
        Map("n", "<leader>vf", require("telescope.builtin").lsp_dynamic_workspace_symbols, lsp_keymap_opts(e, "workspace symbol"))
        Map("n", "<leader>vd", vim.diagnostic.open_float, lsp_keymap_opts(e, "open diagnostic"))
        Map("n", "<leader>vca", vim.lsp.buf.code_action, lsp_keymap_opts(e, "code action"))
        Map("n", "<leader>vrr", vim.lsp.buf.references, lsp_keymap_opts(e, "find references"))
        Map("n", "<leader>vrn", vim.lsp.buf.rename, lsp_keymap_opts(e, "rename"))
        Map("i", "<C-h>", vim.lsp.buf.signature_help, lsp_keymap_opts(e, "signature help"))
        Map("n", "[d", vim.diagnostic.goto_prev, lsp_keymap_opts(e, "previous diagnostic"))
        Map("n", "]d", vim.diagnostic.goto_next, lsp_keymap_opts(e, "next diagnostic"))
    end
})

autocmd("BufWritePre", {
  pattern = "*.go",
  callback = function()
    local params = vim.lsp.util.make_range_params()
    params.context = {only = {"source.organizeImports"}}
    local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params)
    for cid, res in pairs(result or {}) do
      for _, r in pairs(res.result or {}) do
        if r.edit then
          local enc = (vim.lsp.get_client_by_id(cid) or {}).offset_encoding or "utf-16"
          vim.lsp.util.apply_workspace_edit(r.edit, enc)
        end
      end
    end
    vim.lsp.buf.format({async = false})
  end
})

vim.g.netrw_browse_split = 0
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 25
