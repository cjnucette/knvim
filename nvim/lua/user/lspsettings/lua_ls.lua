require('neodev').setup()

return {
	settings = {
		Lua = {
			diagnostics = {
				globals = { 'spec' },
			},
            runtime = {
                special = {
                    spec = 'require'
                },
            },
            hint = {
                enable = true,
                setType = true,
                semicolon = 'All', -- All | SameLine | Disable
            },
            format = {
                enable = true,
                defaultConfig = {
                    indent_style = 'tab',
                    indent_size = '4',
                    quote_style = 'single',
                    call_arg_parentheses = 'keep',
                    max_line_length = 120,
                    align_array_table = false,
                }
            },
			workspace = {
				checkThirdParty = false,
			}
		}
	}
}
