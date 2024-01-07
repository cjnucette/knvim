local opts = function(opt)
	opt = opt or {}
	return vim.tbl_deep_extend('force', { silent = true, noremap = true }, opt)
end

vim.keymap.set('n', '<leader>w', vim.cmd.w, opts({ desc = 'Write buffer to disk' }))
vim.keymap.set('n', '<leader>ev', function() vim.cmd.edit('$MYVIMRC') end, opts({ desc = 'Edit init.lua' }))

vim.keymap.set('n', '<tab>', vim.cmd.bn, opts({ desc = 'Goto the next buffer' }))
vim.keymap.set('n', '<s-tab>', vim.cmd.bp, opts({ desc = 'Goto the prev buffer' }))

-- map('n', '<leader>u', 'mzviw~`z', opts({ desc = 'Toggle capitalization of word under the cursor' }))
vim.keymap.set('n', '<leader>u', 'gUbel', opts({ desc = 'Toggle capitalization of word under the cursor' }))

-- up and down work as expected
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true })

vim.keymap.set('v', '<', '<gv', opts({ desc = 'Un-indent current selection and keep the selection' }))
vim.keymap.set('v', '>', '>gv', opts({ desc = 'Indent current selection and keep the selection' }))

vim.keymap.set('n', '<a-j>', ':m .+1<CR>==', opts({ desc = 'Move current line down keeping indentation' }))
vim.keymap.set('n', '<a-k>', ':m .-2<CR>==', opts({ desc = 'Move current line up keeping indentation' }))
vim.keymap.set('v', '<a-j>', ":m '>+1<CR>gv=gv",
	opts({ desc = 'Move current line up, keeping indentation and selection' }))
vim.keymap.set('v', '<a-k>', ":m '<-2<CR>gv=gv",
	opts({ desc = 'Move current line up, keeping indentation and selection' }))

vim.keymap.set('n', '<leader>cn', ':help news<CR>', opts({ desc = '[C]heck what is [n]ew in neovim' }))

-- Read the current line asynchronously
local say = function()
	local uv = vim.loop
	local handle
	local on_exit = function()
		if handle then
			uv.close(handle)
		end
	end

	handle = uv.spawn('google_speech', { args = { vim.fn.getline('.') } }, on_exit)
end
-- map('n', '<leader>r', [[:execute 'silent !google_speech ' . '"' . getline('.') . '"'<cr>]],
-- 	opts({ desc = '[R]ead aloud the current line' }))
vim.keymap.set('n', '<leader>r', function() say() end, opts({ desc = '[R]ead aloud the current line' }))

-- help about word under cursor
vim.keymap.set('n', '<F1>', ':help <C-r><C-w><CR>', opts({ desc = 'Find help for the word under the cursor' }))

