local icons = require('user.icons')
local map_opts = function(opts)
	opts = opts or {}
	return vim.tbl_deep_extend('force', { silent = true, noremap = true }, opts)
end

local opts = {
	close_if_last_window = true, -- Close Neo-tree if it is the last window left in the tab
	popup_border_style = 'rounded',
	follow_current_file = true,
	enable_git_status = true,
	enable_diagnostics = true,
	source_selector = {
		winbar = true,
		sources = {
			{ source = 'filesystem' },
			{ source = 'git_status' },
			{ source = 'buffers' },
		},
		content_layout = 'center', -- string
		tabs_layout = 'active',
	},
	default_component_configs = {
		container = {
			enable_character_fade = true
		},
		git_status = {
			symbols = {
				-- Change type
				-- NOTE: you can set any of these to an empty string to not show them
				added     = icons.git.add,
				deleted   = icons.git.delete,
				modified  = icons.git.modify,
				renamed   = icons.git.rename,
				untracked = icons.git.untracked,
				ignored   = icons.git.ignored,
				unstaged  = icons.git.unstaged,
				staged    = icons.git.staged, -- f634: 
				conflict  = icons.git.confict,
			},
			align = 'right',
		},
		diagnostics = {
			symbols = {
				hint =  icons.diag.hint,
				info =  icons.diag.information,
				warn =  icons.diag.warning,
				error = icons.diag.error
			}
		}
	},
	window = {
		-- see https://github.com/MunifTanjim/nui.nvim/tree/main/lua/nui/popup for
		width = 30,
		position = 'float',
		popup = {
			-- settings that apply to float position only
			size = {
				height = '70%',
				width = '50%',
			},
		},
		mappings = {
			['l'] = 'open',
			['h'] = 'close_node',
		},
	},
	filesystem = {
		bind_to_cwd = true, -- true creates a 2-way binding between vim's cwd and neo-tree's root
		use_libuv_file_watcher = true, -- This will use the OS level file watchers to detect changes
		-- instead of relying on nvim autocmd events.
	},
}

require('neo-tree').setup(opts)

vim.keymap.set('n', '<leader>e', ':Neotree toggle float<cr>', map_opts({ desc = 'NeoTree: Toggle file explorer' }))
vim.keymap.set('n', '<leader>ef', ':Neotree toggle float<cr>', map_opts({ desc = 'NeoTree: Toggle file explorer' }))
vim.keymap.set('n', '<leader>el', ':Neotree toggle left<cr>', map_opts({ desc = 'NeoTree: Toggle file explorer left' }))
