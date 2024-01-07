local cmd = vim.cmd
local g = vim.g

g.editorconfig = true

-- Native plugins
cmd.filetype('plugin', 'indent', 'on')
cmd.packadd('cfilter') -- Allows filtering the quickfix list with :cfdo

-- let sqlite.lua (which some plugins depend on) know where to find sqlite
vim.g.sqlite_clib_path = require('luv').os_getenv('LIBSQLITE')

-- this should be at the end, because
-- it causes neovim to source ftplugins
-- on the packpath when passing a file to the nvim command
cmd.syntax('on')
cmd.syntax('enable')
