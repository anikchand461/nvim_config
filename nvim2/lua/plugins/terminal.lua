return {
	{
		"akinsho/toggleterm.nvim",
		version = "*",
		event = "VeryLazy",
		init = function()
			-- Optional: hide line numbers in terminals
			vim.api.nvim_create_autocmd("TermOpen", {
				callback = function()
					vim.opt_local.number = false
					vim.opt_local.relativenumber = false
				end,
			})

			-- Auto-map <Esc> to close floating terminal, even from terminal mode
			vim.api.nvim_create_autocmd("TermOpen", {
				callback = function()
					local bufnr = vim.api.nvim_get_current_buf()

					-- Use a small delay to ensure toggleterm has set its vars
					vim.defer_fn(function()
						local direction = pcall(vim.api.nvim_buf_get_var, bufnr, "toggleterm_direction")
						if direction then
							direction = vim.api.nvim_buf_get_var(bufnr, "toggleterm_direction")
							if direction == "float" then
								vim.api.nvim_buf_set_keymap(
									bufnr,
									"t",
									"<Esc>",
									[[<C-\><C-n>:close<CR>]],
									{ noremap = true, silent = true }
								)
							end
						end
					end, 10) -- 10ms delay
				end,
			})
		end,
		config = function()
			require("toggleterm").setup({
				size = function(term)
					if term.direction == "vertical" then
						return 50
					elseif term.direction == "horizontal" then
						return 12
					end
					return 12
				end,
				open_mapping = nil,
				hide_numbers = true,
				shade_filetypes = {},
				shade_terminals = true,
				shading_factor = 2,
				start_in_insert = true,
				insert_mappings = true,
				persist_size = true,
				close_on_exit = true,
				shell = vim.o.shell,
				float_opts = {
					border = "curved",
					winblend = 0,
					highlights = {
						border = "Normal",
						background = "Normal",
					},
				},
			})
		end,
	},
}
