local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- LSP
local keymap = vim.keymap

--- Don't create a comment string when hitting <Enter> on a comment line
autocmd('BufEnter', {
  group = augroup('DisableNewLineAutoCommentString', {}),
  callback = function()
    vim.opt.formatoptions = vim.opt.formatoptions - { 'c', 'r', 'o' }
  end,
})

autocmd('LspAttach', {
  group = augroup('UserLspConfig', {}),
  callback = function(ev)
    local bufnr = ev.buf
    local client = vim.lsp.get_client_by_id(ev.data.client_id)

    -- Enable completion triggered by <c-x><c-o>
    vim.bo[bufnr].omnifunc = 'v:lua.vim.lsp.omnifunc'
    local function desc(description)
      return { noremap = true, silent = true, buffer = bufnr, desc = description }
    end
    keymap.set('n', 'gD', vim.lsp.buf.declaration, desc('[lsp] go to declaration'))
    keymap.set('n', 'gd', vim.lsp.buf.definition, desc('[lsp] go to definition'))
    keymap.set('n', '<space>gt', vim.lsp.buf.type_definition, desc('[lsp] go to type definition'))
    keymap.set('n', 'K', vim.lsp.buf.hover, desc('[lsp] hover'))
    keymap.set('n', 'gi', vim.lsp.buf.implementation, desc('[lsp] go to implementation'))
    keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, desc('[lsp] signature help'))
    keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, desc('[lsp] add workspace folder'))
    keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, desc('[lsp] remove workspace folder'))
    keymap.set('n', '<space>wl', function()
      vim.print(vim.lsp.buf.list_workspace_folders())
    end, desc('[lsp] list workspace folders'))
    keymap.set('n', '<F2>', vim.lsp.buf.rename, desc('[lsp] rename'))
    keymap.set('n', '<space>wq', vim.lsp.buf.workspace_symbol, desc('[lsp] workspace symbol'))
    keymap.set('n', '<space>dd', vim.lsp.buf.document_symbol, desc('[lsp] document symbol'))
    keymap.set('n', '<F4>', vim.lsp.buf.code_action, desc('[lsp] code action'))
    keymap.set('n', '<M-l>', vim.lsp.codelens.run, desc('[lsp] run code lens'))
    keymap.set('n', '<space>cr', vim.lsp.codelens.refresh, desc('[lsp] refresh code lenses'))
    keymap.set('n', 'gr', vim.lsp.buf.references, desc('[lsp] find references'))
    keymap.set('n', '<space>f', function()
      vim.lsp.buf.format { async = true }
    end, desc('[lsp] format buffer'))
    keymap.set('n', '<space>ti', function()
      vim.lsp.inlay_hint(bufnr)
    end, desc('[lsp] toggle inlay hints'))

    -- Auto-refresh code lenses
    if not client then
      return
    end
    local function buf_refresh_codeLens()
      vim.schedule(function()
        if client.server_capabilities.codeLensProvider then
          vim.lsp.codelens.refresh()
          return
        end
      end)
    end
    local group = vim.api.nvim_create_augroup(string.format('lsp-%s-%s', bufnr, client.id), {})
    if client.server_capabilities.codeLensProvider then
      vim.api.nvim_create_autocmd({ 'InsertLeave', 'BufWritePost', 'TextChanged' }, {
        group = group,
        callback = buf_refresh_codeLens,
        buffer = bufnr,
      })
      buf_refresh_codeLens()
    end
  end,
})

-- More examples, disabled by default

-- Toggle between relative/absolute line numbers
-- Show relative line numbers in the current buffer,
-- absolute line numbers in inactive buffers
-- local numbertoggle = vim.api.nvim_create_augroup('numbertoggle', { clear = true })
-- vim.api.nvim_create_autocmd({ 'BufEnter', 'FocusGained', 'InsertLeave', 'CmdlineLeave', 'WinEnter' }, {
--   pattern = '*',
--   group = numbertoggle,
--   callback = function()
--     if vim.o.nu and vim.api.nvim_get_mode().mode ~= 'i' then
--       vim.opt.relativenumber = true
--     end
--   end,
-- })
-- vim.api.nvim_create_autocmd({ 'BufLeave', 'FocusLost', 'InsertEnter', 'CmdlineEnter', 'WinLeave' }, {
--   pattern = '*',
--   group = numbertoggle,
--   callback = function()
--     if vim.o.nu then
--       vim.opt.relativenumber = false
--       vim.cmd.redraw()
--     end
--   end,
-- })


local user_cmds = augroup('user_autocommands', { clear = true })
autocmd(
	'FileType',
	{
		desc = 'Use q to close the window',
		group = user_cmds,
		pattern = { 'oil', 'help', 'man', 'fugitive', 'qf', 'notify', 'lspinfo', 'checkhealth', 'git' },
		command = 'nnoremap <buffer> q :quit<cr>'
	}
)

autocmd(
	'TextYankPost',
	{
		desc = 'Highlight yanked objects',
		group = user_cmds,
		callback = function()
			vim.highlight.on_yank({ higroup = 'Visual', timeout = 200 })
		end
	}
)

autocmd('BufRead', {
	desc = 'Place the cursor on the last place you where in a file and center buffer around it',
	group = user_cmds,
	callback = function()
		local mark = vim.api.nvim_buf_get_mark(0, '"')
		local lcount = vim.api.nvim_buf_line_count(0)
		if mark[1] > 0 and mark[1] <= lcount then
			if pcall(vim.api.nvim_win_set_cursor, 0, mark) then
				vim.cmd.normal('zz')
			end
		end
	end,
})

autocmd({ 'FocusGained', 'TermClose', 'TermLeave' }, {
	desc = 'Check for external changes to file and reload it',
	group = user_cmds,
	command = 'checktime',
})

-- autocmd('BufWritePre', {
--  desc = "Create directory when needed, when saving a file"
-- 	group = user_cmds,
-- 	callback = function(event)
-- 		local file = vim.loop.fs_realpath(event.match) or event.match
--
-- 		vim.fn.mkdir(vim.fn.fnamemodify(file, ':p:h'), 'p')
-- 		local backup = vim.fn.fnamemodify(file, ':p:~:h')
-- 		backup = backup:gsub('[/\\]', '%%')
-- 		vim.go.backupext = backup
-- 	end
-- })

vim.api.nvim_create_autocmd('BufNewFile', {
	desc = 'Load skeleton file when a new empty file is created.',
	group = vim.api.nvim_create_augroup('init-lua', { clear = true }),
	callback = function()
		local skeleton_name = vim.fn.stdpath('config') .. '/templates/skeleton.' .. vim.fn.expand('<afile>:e')
		if vim.loop.fs_stat(skeleton_name) then
			vim.cmd.read({ args = { skeleton_name }, range = { 0, 0 } })
		end
	end,
})

-- saves the current state of a buffer
local view_group = augroup('auto_view', { clear = true })

autocmd({ 'BufWinLeave', 'BufWritePost', 'WinLeave' }, {
	desc = 'Save view with mkview for real files',
	group = view_group,
	callback = function(args)
		if vim.b[args.buf].view_activated then vim.cmd.mkview { mods = { emsg_silent = true } } end
	end,
})

autocmd('BufWinEnter', {
	desc = 'Try to load file view if available and enable view saving for real files',
	group = view_group,
	callback = function(args)
		if not vim.b[args.buf].view_activated then
			local filetype = vim.api.nvim_get_option_value('filetype', { buf = args.buf })
			local buftype = vim.api.nvim_get_option_value('buftype', { buf = args.buf })
			local ignore_filetypes = { 'gitcommit', 'gitrebase', 'svg', 'hgcommit' }
			if buftype == '' and filetype and filetype ~= '' and not vim.tbl_contains(ignore_filetypes, filetype) then
				vim.b[args.buf].view_activated = true
				vim.cmd.loadview { mods = { emsg_silent = true } }
			end
		end
	end,
})
