return {
	{
		"saghen/blink.cmp",
		lazy = false, -- lazy loading handled internally
		-- optional: provides snippets for the snippet source
		-- dependencies = "rafamadriz/friendly-snippets",

		-- use a release tag to download pre-built binaries
		version = "v0.*",
		dependencies = "L3MON4D3/LuaSnip",
		-- OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
		-- build = 'cargo build --release',
		-- If you use nix, you can build from source using latest nightly rust with:
		-- build = 'nix run .#build-plugin',

		---@module 'blink.cmp'
		---@type blink.cmp.Config
		opts = {
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
				cmdline = {},
			},
			-- sources = {
			-- 	default = { "lsp", "path", "buffer", "luasnip" },
			-- },
			-- 'default' for mappings similar to built-in completion
			-- 'super-tab' for mappings similar to vscode (tab to accept, arrow keys to navigate)
			-- 'enter' for mappings similar to 'super-tab' but with 'enter' to accept
			-- see the "default configuration" section below for full documentation on how to define
			-- your own keymap.
			keymap = {
  ["<S-Tab>"] = { "select_prev", "fallback" },         -- previous suggestion
  ["<Tab>"] = { "select_next", "fallback" },           -- next suggestion
  ["<C-b>"] = { "scroll_documentation_up", "fallback" },    -- scroll docs up
  ["<C-f>"] = { "scroll_documentation_down", "fallback" },  -- scroll docs down
  ["<C-Space>"] = { "show", "show_documentation" },     -- show completion suggestions
  ["<C-e>"] = { "hide", "fallback" },                  -- close completion window
  ["<CR>"] = { "accept", "fallback" }         
			},

			appearance = {
				-- Sets the fallback highlight groups to nvim-cmp's highlight groups
				-- Useful for when your theme doesn't support blink.cmp
				-- will be removed in a future release
				use_nvim_cmp_as_default = false,
				-- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
				-- Adjusts spacing to ensure icons are aligned
				nerd_font_variant = "mono",
			},

			-- default list of enabled providers defined so that you can extend it
			-- elsewhere in your config, without redefining it, via `opts_extend`

			completion = {
				menu = {
					border = 'rounded',
					auto_show = function()
						return vim.bo.buftype ~= "prompt" and vim.b.completion ~= false and vim.bo.filetype ~= "TelescopePrompt"
					end,
				},
				documentation = {
					auto_show = true,
					window = {
						border = 'rounded'
					},
				},
			},

			-- accept = {
			-- 	auto_brackets = {
			-- 		enabled = true,
			-- 	},
			-- },

			-- experimental signature help support
			-- signature = { enabled = true }
		},
		-- allows extending the providers array elsewhere in your config
		-- without having to redefine it
		opts_extend = { "sources.default" },
	},
}

