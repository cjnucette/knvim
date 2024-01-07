local inlay_hints = {
	includeInlayParameterNameHints = 'all', -- 'none' | 'literals' | 'all';
	includeInlayParameterNameHintsWhenArgumentMatchesName = true,
	includeInlayFunctionParameterTypeHints = true,
	includeInlayVariableTypeHints = true,
	includeInlayVariableTypeHintsWhenTypeMatchesName = true,
	includeInlayPropertyDeclarationTypeHints = true,
	includeInlayFunctionLikeReturnTypeHints = true,
	includeInlayEnumMemberValueHints = true,
}
return {
		settings = {
			javascript = {
				inlayHints = inlay_hints,
			},
			typescript = {
				inlayHints = inlay_hints,
			}
		},
}
