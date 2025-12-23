-- CLEAN & CENTERED DASHBOARD (SMALL BOX + GRADIENT + FADE-IN)

local logo = {
	" ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗",
	" ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║",
	" ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║",
	" ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║",
	" ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║",
	" ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝",
	"                                                   ",
	"                 Welcome, Anik                     ",
}

local function strwidth(s)
	return vim.fn.strdisplaywidth(s)
end

-- 🌈 Neovim-style gradient colors (green → blue)
local gradient = {
	"#8ccf7e",
	"#9ece6a",
	"#a7c080",
	"#7aa2f7",
	"#82aaff",
	"#7dcfff",
}

-- Highlights (colorscheme-safe)
vim.api.nvim_create_autocmd("ColorScheme", {
	callback = function()
		for i, color in ipairs(gradient) do
			vim.api.nvim_set_hl(0, "DashboardLogo" .. i, { fg = color, bold = true })
		end
		vim.api.nvim_set_hl(0, "DashboardTitle", { fg = "#9ece6a", bold = true })
		vim.api.nvim_set_hl(0, "DashboardHint", { fg = "#565f89", italic = true })
	end,
})

-- Apply immediately
for i, color in ipairs(gradient) do
	vim.api.nvim_set_hl(0, "DashboardLogo" .. i, { fg = color, bold = true })
end
vim.api.nvim_set_hl(0, "DashboardTitle", { fg = "#9ece6a", bold = true })
vim.api.nvim_set_hl(0, "DashboardHint", { fg = "#565f89", italic = true })

vim.api.nvim_create_autocmd("VimEnter", {
	callback = function()
		if vim.fn.argc() > 0 then
			return
		end

		local ui = vim.api.nvim_list_uis()[1]

		-- Calculate box size
		local logo_width = 0
		for _, l in ipairs(logo) do
			logo_width = math.max(logo_width, strwidth(l))
		end

		local box_width = logo_width + 10
		local box_height = #logo + 6

		local row = math.floor((ui.height - box_height) / 2)
		local col = math.floor((ui.width - box_width) / 2)

		local buf = vim.api.nvim_create_buf(false, true)
		local win = vim.api.nvim_open_win(buf, true, {
			relative = "editor",
			row = row,
			col = col,
			width = box_width,
			height = box_height,
			style = "minimal",
			border = "rounded",
		})

		-- Prepare empty buffer
		local content = {}
		for _ = 1, box_height do
			table.insert(content, "")
		end
		vim.api.nvim_buf_set_lines(buf, 0, -1, false, content)

		-- Vertical centering
		local logo_start = math.max(2, math.floor((box_height - #logo) / 2))

		-- Render logo (fully, once)
		for i, line in ipairs(logo) do
			local pad = math.floor((box_width - strwidth(line)) / 2)
			local row_idx = logo_start + i - 1

			vim.api.nvim_buf_set_lines(buf, row_idx, row_idx + 1, false, { string.rep(" ", pad) .. line })

			local hl = "DashboardLogo" .. ((i - 1) % #gradient + 1)
			vim.api.nvim_buf_add_highlight(buf, -1, hl, row_idx, 0, -1)
		end

		-- Buffer options
		-- vim.bo[buf].modifiable = false
		vim.bo[buf].buftype = "nofile"
		vim.bo[buf].bufhidden = "wipe"
		vim.bo[buf].swapfile = false

		vim.wo[win].number = false
		vim.wo[win].relativenumber = false
		vim.wo[win].cursorline = false

		-- Close on ANY key
		vim.defer_fn(function()
			vim.fn.getchar()
			if vim.api.nvim_win_is_valid(win) then
				vim.api.nvim_win_close(win, true)
			end
		end, 20)
	end,
})
