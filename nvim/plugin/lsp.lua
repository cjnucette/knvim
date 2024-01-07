local lspconfig = require('lspconfig')
local servers = { 'lua_ls', 'nixd' }

local default_capabilities = function()
    local ok, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
    if ok then
        return cmp_nvim_lsp.default_capabilities()
    end

    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities.textDocument.completion.completionItem.snippetSupport = true
    capabilities.textDocument.completion.completionItem.resolveSupport = {
        properties = {
            "documentation",
            "detail",
            "additionalTextEdits",
        }
    }

    return capabilities
end

local opts = function(lsp)
	local defaults = {
		-- on_attach = default_on_attach,
		capabilities = default_capabilities()
	}
	local ok, server = pcall(require, 'user.lspsettings.' .. lsp)
	if not ok then server = {} end

	return vim.tbl_deep_extend(
		'force',
		defaults,
		server
	)
end

for _, lsp in ipairs(servers) do
	lspconfig[lsp].setup(opts(lsp))
end
