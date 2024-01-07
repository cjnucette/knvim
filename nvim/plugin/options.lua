-- setup leader
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- settings
vim.opt.hidden = true
vim.opt.mouse = 'a'
vim.opt.modeline = true
vim.opt.updatetime = 200 -- Save swap file and triggers CursorHold
vim.opt.autoread = true
vim.opt.exrc = true
vim.opt.shortmess:append({ W = true, c = true, C = true })

vim.opt.confirm = true

vim.opt.number = true
vim.opt.signcolumn = 'number'

-- color support
vim.opt.background = 'dark'
vim.opt.termguicolors = true

--statusline
vim.opt.cmdheight = 0
vim.opt.laststatus = 3
vim.opt.showmode = false

vim.opt.tabstop = 4
vim.opt.shiftwidth = 0   -- uses tabstop's value
vim.opt.softtabstop = -1 -- uses shiftwidth's value
vim.opt.expandtab = false
vim.opt.shiftround = true
vim.opt.smartindent = true

vim.opt.cursorline = true
vim.opt.splitbelow = true
vim.opt.splitright = true

vim.opt.wrap = false
vim.opt.breakindent = true

vim.opt.digraph = false
vim.opt.nrformats:append({ 'alpha' })

vim.opt.ignorecase = false
vim.opt.smartcase = true
vim.opt.incsearch = true
vim.opt.hlsearch = false

vim.opt.list = true
vim.opt.listchars = { tab = '  ', trail = '·' }
vim.opt.fillchars = { eob = ' ' } -- removes those pesky ~ at the end of the file
vim.opt.iskeyword:append('-')

vim.opt.wildmode = 'longest:full,full'

vim.opt.clipboard:append({ 'unnamed', 'unnamedplus' })

vim.opt.backup = false
vim.opt.writebackup = false

-- autocomplete window transparency --
vim.opt.pumblend = 10
vim.opt.pumheight = 10
vim.opt.winblend = 10

vim.opt.splitkeep = 'screen'

--- undo ---
if vim.fn.has('persistent_undo') then
	vim.opt.undodir = vim.fn.expand('~/.undodir') -- ~ doesn't expand in lua
	vim.opt.undofile = true
	vim.opt.undolevels = 10000
end


