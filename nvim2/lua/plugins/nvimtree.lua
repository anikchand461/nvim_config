return {
	"nvim-tree/nvim-tree.lua",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
	config = function()
		require("nvim-tree").setup({
			-- Disable line numbers and relative numbers in NvimTree
			view = {
				width = 20,
				signcolumn = "no",
				relativenumber = false, -- ❌ disable relative numbers
				number = false, -- ❌ disable absolute numbers
			},

			-- Optional: other common settings
			on_attach = function(bufnr)
				local api = require("nvim-tree.api")

				local function opts(desc)
					return {
						desc = "nvim-tree: " .. desc,
						buffer = bufnr,
						noremap = true,
						silent = true,
						nowait = true,
					}
				end

				-- Default mappings
				api.config.mappings.default_on_attach(bufnr)

				-- Custom mappings (optional)
				vim.keymap.set("n", "t", api.node.open.tab, opts("Tab"))
			end,

			actions = {
				open_file = {
					quit_on_open = true,
				},
			},
			sort = {
				sorter = "case_sensitive",
			},
			filters = {
				dotfiles = true,
				custom = {
					"node_modules/.*",
				},
			},
			log = {
				enable = true,
				truncate = true,
				types = {
					diagnostics = true,
					git = true,
					profile = true,
					watcher = true,
				},
			},
		})

		-- Optional: auto-open NvimTree on startup if no args
		if vim.fn.argc(-1) == 0 then
			vim.cmd("NvimTreeFocus")
		end
	end,
}
