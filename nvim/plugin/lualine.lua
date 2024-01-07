---Indicators for special modes,
---@return string status
local function extra_mode_status()
  -- recording macros
  local reg_recording = vim.fn.reg_recording()
  if reg_recording ~= '' then
    return ' @' .. reg_recording
  end
  -- executing macros
  local reg_executing = vim.fn.reg_executing()
  if reg_executing ~= '' then
    return ' @' .. reg_executing
  end
  -- ix mode (<C-x> in insert mode to trigger different builtin completion sources)
  local mode = vim.api.nvim_get_mode().mode
  if mode == 'ix' then
    return '^X: (^]^D^E^F^I^K^L^N^O^Ps^U^V^Y)'
  end
  return ''
end

local main_color = 'StatusLine'

local sections_colors = {
	a = main_color,
	b = main_color,
	c = main_color,
	x = main_color,
	y = main_color,
	z = main_color,
}
local mono_theme = {
	normal = sections_colors,
	insert = sections_colors,
	visual = sections_colors,
	replace = sections_colors,
	command = sections_colors,
	inactive = sections_colors,
}

local function location()
	return 'Ln %l,Col %c'
end

local function get_package_info()
	return require('package-info').get_status()
end

local function get_lsp_names()
	local hide = {'null-ls', 'emmet_language_server' }
	local client_names = vim.lsp.get_clients({ buffer = 0})

	local names = ''
	for _, client in ipairs(client_names) do
	  if not vim.tbl_contains(hide, client.name) then
		  names = names .. client.name
	  end
 	end

	return vim.trim(names)
end

local lsp_status = {
	'lsp_progress',
	separators = {
		lsp_client_name = { pre = '', post = ''},
	},
	hide = {'null-ls', 'emmet_language_server', 'eslint' },
	spinner_symbols = { '✶', '✸', '✹', '✺', '✹', '✸', '✷' },
	only_show_attaced = true,
	display_components = { 'spinner' },
	timer = {
		lsp_client_name_enddelay = 0
	},
}

require('lualine').setup {
  options = {
	  globalstatus = true,
	  component_separators = { left = '', right = ''},
	  section_separators = { left = '', right = ''},
	  theme = mono_theme,
  },
  sections = {
	lualine_a = { 'diagnostics' },
    lualine_b = { 'mode', 'branch', 'diff' },
	lualine_c = { get_lsp_names, lsp_status, get_package_info},
	lualine_x = { location },
	lualine_y = { "filetype" },
    lualine_z = {
	  "os.date('%I:%M %p')",
      { extra_mode_status },
    },
  },
  extensions = { 'fugitive', 'fzf', 'toggleterm', 'quickfix', 'man', 'neo-tree' },
}
