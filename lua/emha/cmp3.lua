return {
	{
		"saghen/blink.compat",
		-- use the latest release, via version = '*', if you also use the latest release for blink.cmp
		version = "*",
		-- lazy.nvim will automatically load the plugin when it's required by blink.cmp
		lazy = true,
		-- make sure to set opts so that lazy.nvim calls blink.compat's setup
		opts = {
			-- some plugins lazily register their completion source when nvim-cmp is
			-- loaded, so pretend that we are nvim-cmp, and that nvim-cmp is loaded.
			-- most plugins don't do this, so this option should rarely be needed
			-- NOTE: only has effect when using lazy.nvim plugin manager
			impersonate_nvim_cmp = false,

			-- print some debug information. Might be useful for troubleshooting
			debug = false,
		},
	},
	{
		"saghen/blink.cmp",
		lazy = false,
		version = "v0.*",
		dependencies = {
			"L3MON4D3/LuaSnip",
			"rafamadriz/friendly-snippets",
			"onsails/lspkind.nvim", -- Add LSPKind dependency
		},
		opts = function(_, opts)
			return vim.tbl_deep_extend("force", opts, {
				snippets = {
					expand = function(snippet)
						require("luasnip").lsp_expand(snippet)
					end,
					active = function(filter)
						if filter and filter.direction then
							return require("luasnip").jumpable(filter.direction)
						end
						return require("luasnip").in_snippet()
					end,
					jump = function(direction)
						require("luasnip").jump(direction)
					end,
				},
				sources = {
					-- add lazydev to your completion providers
					default = { "lsp", "path", "snippets", "buffer", "lazydev" },
					providers = {
						-- dont show LuaLS require statements when lazydev has items
						lazydev = {
							name = "LazyDev",
							module = "lazydev.integrations.blink",
							fallbacks = { "lsp" },
						},
					},
				},
				keymap = {
					["<S-Tab>"] = { "select_prev", "fallback" },
					["<Tab>"] = { "select_next", "fallback" },
					["<C-b>"] = { "scroll_documentation_up", "fallback" },
					["<C-f>"] = { "scroll_documentation_down", "fallback" },
					["<C-Space>"] = { "show", "show_documentation" },
					["<C-e>"] = { "hide", "fallback" },
					["<CR>"] = { "accept", "fallback" },
				},
				appearance = {
					use_nvim_cmp_as_default = true,
					nerd_font_variant = "mono",
					kind_icons = {
						Array = " ",
						Boolean = "󰨙 ",
						Class = " ",
						Codeium = "󰘦 ",
						Color = " ",
						Control = " ",
						Collapsed = " ",
						Constant = "󰏿 ",
						Constructor = " ",
						Copilot = " ",
						Enum = " ",
						EnumMember = " ",
						Event = " ",
						Field = " ",
						File = " ",
						Folder = " ",
						Function = "󰊕 ",
						Interface = " ",
						Key = " ",
						Keyword = " ",
						Method = "󰊕 ",
						Module = " ",
						Namespace = "󰦮 ",
						Null = " ",
						Number = "󰎠 ",
						Object = " ",
						Operator = " ",
						Package = " ",
						Property = " ",
						Reference = " ",
						Snippet = "󱄽 ",
						String = " ",
						Struct = "󰆼 ",
						Supermaven = " ",
						TabNine = "󰏚 ",
						Text = " ",
						TypeParameter = " ",
						Unit = " ",
						Value = " ",
						Variable = "󰀫 ",
					},
				},
				completion = {
					menu = {
						border = "rounded",
						draw = {
							columns = {
								{ "kind_icon" },
								{ "label", "label_description", "source_name", gap = 1 },
							},
							components = {
								kind_icon = {
									text = function(ctx)
										if ctx.source_id == "cmdline" then
											return
										end
										return ctx.kind_icon .. ctx.icon_gap
									end,
								},
								label = { width = { fill = false } },
								label_description = {
									width = { fill = true },
								},
								source_name = {
									text = function(ctx)
										if ctx.source_id == "cmdline" then
											return
										end
										return ctx.source_name:sub(1, 4)
									end,
								},
							},
							treesitter = {
								"lsp",
							},
						},
						auto_show = function()
							return vim.bo.buftype ~= "prompt"
								and vim.b.completion ~= false
								and vim.bo.filetype ~= "TelescopePrompt"
						end,
					},
					documentation = {
						auto_show = true,
						window = {
							border = "rounded",
						},
					},
					list = {
						selection = {
							preselect = false, -- Disable preselection
							auto_insert = false, -- Disable auto-insert
						},
					},
				},
			})
		end,
		opts_extend = { "sources.default" },
	},
}
