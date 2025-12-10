-- =========================
--  Neovim IDE Setup (Anik)
-- =========================

vim.g.mapleader = " "

-- ---------- lazy.nvim bootstrap ----------
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,

    })
end
vim.opt.rtp:prepend(lazypath)

-- ---------- Plugins ----------
require("lazy").setup({

  -- FILE EXPLORER
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("nvim-tree").setup()
      vim.keymap.set("n", "<C-n>", ":NvimTreeToggle<CR>", { silent = true, desc = "Toggle file tree" })
    end,
  },
{
  "nvim-tree/nvim-web-devicons",
  lazy = true,
},
      -- TABS BAR (like Sublime / VS Code)
  {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = "nvim-tree/nvim-web-devicons",
    config = function()
      vim.opt.termguicolors = true
      require("bufferline").setup({
        options = {
          diagnostics = "nvim_lsp",
          offsets = {
            { filetype = "NvimTree", text = "Files", separator = true },
          },
        },
      })
    end,
  },


 -- COMMENT TOGGLE (Ctrl+/ like VS Code)
  {
    "numToStr/Comment.nvim",
    config = function()
      require("Comment").setup()
    end,
  },
-- GitHub themes
{
  "projekt0n/github-nvim-theme",
  lazy = true,           -- lazy load (we'll set the colorscheme when we want)
  priority = 1000,       -- load early if you set it as default
  config = function()
    -- optional: any plugin-specific config could go here
    -- (github-nvim-theme typically doesn't require setup for basic use)
  end,
},

      -- THEMES ---------------------------------------
  {
    "ellisonleao/gruvbox.nvim",
    lazy = true,
  },
  {
    "navarasu/onedark.nvim",
    lazy = true,
  },
  {
    "EdenEast/nightfox.nvim",
    lazy = true,
  },
  {
    "sainnhe/everforest",
    lazy = true,
  },
  -- ---------------------------------------------
  -- STATUSLINE
-- FILE ICONS
{
  "nvim-tree/nvim-web-devicons",
  lazy = true,
  config = function()
    require("nvim-web-devicons").setup({
      default = true,  -- use default icons for everything
    })
  end,
},

-- FILE EXPLORER (NvimTree) WITH ICONS

{
  "nvim-tree/nvim-tree.lua",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    require("nvim-tree").setup({
      renderer = {
        highlight_git = true,
        indent_markers = { enable = true },
        icons = {
          show = {
            file = true,
            folder = true,
            folder_arrow = true,
            git = true,
          },
        },
      },
    })

    vim.keymap.set("n", "<C-n>", ":NvimTreeToggle<CR>", { silent = true, noremap = true })
  end,
},


  -- TELESCOPE (fuzzy finder)
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local builtin = require("telescope.builtin")
      vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find files" })
      vim.keymap.set("n", "<leader>fg", builtin.live_grep,  { desc = "Live grep" })
      vim.keymap.set("n", "<leader>fb", builtin.buffers,    { desc = "List buffers" })
    end,
  },

      -- SMOOTH SCROLLING
  {
    "karb94/neoscroll.nvim",
    config = function()
      require("neoscroll").setup({
        -- you can tweak these later
        easing_function = "quadratic",
      })
      -- Optional: smoother mappings for common scrolling keys
      local t = {}
      t["<C-u>"] = { "scroll", { "-vim.wo.scroll", "true", "200" } }
      t["<C-d>"] = { "scroll", { "vim.wo.scroll", "true", "200" } }
      t["<C-b>"] = { "scroll", { "-vim.api.nvim_win_get_height(0)", "true", "300" } }
      t["<C-f>"] = { "scroll", { "vim.api.nvim_win_get_height(0)", "true", "300" } }
      t["<C-y>"] = { "scroll", { "-0.10", "false", "100" } }
      t["<C-e>"] = { "scroll", { "0.10", "false", "100" } }

      require("neoscroll.config").set_mappings(t)
    end,
  },


  -- TOGGLETERM (terminal on RIGHT side)
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = function()
      require("toggleterm").setup({
        size = 40,                    -- width of right terminal
        open_mapping = [[<C-\>]],     -- Ctrl+\
        direction = "vertical",       -- RIGHT side
        shade_terminals = true,
      })
      vim.keymap.set("n", "<leader>tt", ":ToggleTerm<CR>", { silent = true, desc = "Toggle terminal" })
    end,
  },


  -- AUTOCOMPLETE (nvim-cmp + LuaSnip)
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
      "rafamadriz/friendly-snippets",
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")

      require("luasnip.loaders.from_vscode").lazy_load()

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<CR>"]      = cmp.mapping.confirm({ select = true }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },   -- language-specific suggestions
          { name = "luasnip" },    -- snippets
          { name = "buffer" },
          { name = "path" },
        }),
      })
    end,
  },

    {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    dependencies = { "hrsh7th/nvim-cmp" },
    config = function()
      local npairs = require("nvim-autopairs")
      npairs.setup({
        check_ts = true,  -- treesitter awareness
        fast_wrap = {},
      })

      -- Integrate with autocomplete (nvim-cmp)
      local cmp_autopairs = require("nvim-autopairs.completion.cmp")
      local cmp = require("cmp")
      cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
    end,
  },


})

require("nvim-tree").setup({
  renderer = {
    icons = {
      show = {
        file = true,
        folder = true,
        folder_arrow = true,
        git = true,
      },
    },
  },
})


-- =========================
--  Theme switching
-- =========================
vim.o.termguicolors = true

local themes = {
  "tokyonight-night",
  "catppuccin-macchiato",
  "gruvbox",
  "onedark",
  "nightfox",
  "everforest",
    -- GitHub theme variants (projekt0n/github-nvim-theme)
  "github_dark",            -- "GitHub Dark"
  "github_dark_dimmed",     -- "GitHub Dark Dimmed"
  "github_dark_tritanopia", -- "GitHub Dark (tritanopia)"
  "github_dark_default",    -- some users reference this; fallback to github_dark if not present
  "github_light"           -- "GitHub Light"
}

local current_theme_index = 1


-- Apply theme safely
local function apply_theme(idx)
  if idx < 1 or idx > #themes then return end

  current_theme_index = idx
  local theme = themes[idx]

  local ok, err = pcall(vim.cmd, "colorscheme " .. theme)
  if not ok then
    vim.notify("Could not load theme: " .. theme .. "\n" .. err,
      vim.log.levels.WARN
    )

    -- fallback theme
    pcall(vim.cmd, "colorscheme github_dark")
  else
    vim.notify("Theme: " .. theme)
  end
end


-- KEYMAPS: Switch themes quickly
vim.keymap.set("n", "<leader>tn", function()
  apply_theme((current_theme_index % #themes) + 1)
end)

vim.keymap.set("n", "<leader>tp", function()
  local prev = current_theme_index - 1
  if prev < 1 then prev = #themes end
  apply_theme(prev)
end)


-- Load initial theme when NVIM starts
apply_theme(current_theme_index)

-- ---------- Basic options ----------
vim.o.number = true
vim.o.relativenumber = true
vim.o.termguicolors = true
vim.o.expandtab = true
vim.o.shiftwidth = 4
vim.o.tabstop = 4
vim.o.smartindent = true
vim.o.cursorline = true
vim.opt.number = true
vim.opt.relativenumber = false
vim.g.lazy_show_ui = false
vim.o.mouse = "a"
vim.opt.numberwidth = 4
vim.o.winbar = "%=%m %f"

-- ======================
-- Autosave (IDE style)
-- ======================
local autosave_group = vim.api.nvim_create_augroup("Autosave", { clear = true })

vim.api.nvim_create_autocmd({ "InsertLeave", "TextChanged", "TextChangedI" }, {
  group = autosave_group,
  pattern = "*",
  callback = function()
    if vim.bo.modifiable and vim.bo.buftype == "" and vim.fn.expand("%") ~= "" then
      vim.cmd("silent write")
    end
  end,
})


-- =========================
--  Plugins
-- =========================
require("lazy").setup({

  ui = {
    open = nil,  -- ← this fully disables the lazy window auto-open
  },

    -- tab resize
{
  "nvim-lualine/lualine.nvim",
  config = function()
    require("lualine").setup({
      options = {
        icons_enabled = true,
        theme = "auto",
        globalstatus = false,
      },
      winbar = {
        lualine_a = {'filename'},
      },
      inactive_winbar = {
        lualine_a = {'filename'},
      },
    })
  end,
},

  -- FILE EXPLORER (sidebar)
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("nvim-tree").setup()
      vim.keymap.set("n", "<C-n>", ":NvimTreeToggle<CR>", { silent = true, desc = "Toggle file tree" })
    end,
  },

  -- STATUSLINE
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup({
        options = {
          theme = "auto",
          icons_enabled = true,
        },
      })
    end,
  },

  -- TREESITTER (syntax & indent)
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = {
          "python", "lua", "javascript", "typescript",
          "html", "css", "java", "c", "cpp",
          "bash", "json", "markdown", "vim", "yaml",
        },
        highlight = { enable = true },
        indent = { enable = true },
      })
    end,
  },

  -- TELESCOPE (fuzzy finder)
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local builtin = require("telescope.builtin")
      vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find files" })
      vim.keymap.set("n", "<leader>fg", builtin.live_grep,  { desc = "Live grep" })
      vim.keymap.set("n", "<leader>fb", builtin.buffers,    { desc = "List buffers" })
    end,
  },

  -- TERMINAL (right side)
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = function()
      require("toggleterm").setup({
        size = 40,
        open_mapping = [[<C-\>]],
        direction = "vertical",
        shade_terminals = true,
      })
      vim.keymap.set("n", "<leader>tt", ":ToggleTerm<CR>", { silent = true, desc = "Toggle terminal" })
    end,
  },

  -- MASON
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end,
  },

  -- LSP
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "neovim/nvim-lspconfig", "hrsh7th/cmp-nvim-lsp" },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "pyright", "tsserver", "lua_ls", "html",
          "cssls", "jsonls", "clangd", "bashls",
        },
      })

      local lspconfig = require("lspconfig")
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      local on_attach = function(_, bufnr)
        local map = function(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
        end
        map("n", "gd", vim.lsp.buf.definition)
        map("n", "K", vim.lsp.buf.hover)
        map("n", "<leader>rn", vim.lsp.buf.rename)
        map("n", "<leader>ca", vim.lsp.buf.code_action)
      end

      for _, server in ipairs({
        "pyright", "tsserver", "lua_ls", "html",
        "cssls", "jsonls", "clangd", "bashls",
      }) do
        lspconfig[server].setup({
          capabilities = capabilities,
          on_attach = on_attach,
        })
      end
    end,
  },

  -- AUTOCOMPLETE
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
      "rafamadriz/friendly-snippets",
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")

      require("luasnip.loaders.from_vscode").lazy_load()

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<CR>"]      = cmp.mapping.confirm({ select = true }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
        sources = {
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "buffer" },
          { name = "path" },
        },
      })
    end,
  },

  -- AUTOPAIRS
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    dependencies = { "hrsh7th/nvim-cmp" },
    config = function()
      local npairs = require("nvim-autopairs")
      npairs.setup({})
      local cmp = require("cmp")
      local cmp_autopairs = require("nvim-autopairs.completion.cmp")
      cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
    end,
  },

})

-- =========================
-- KEYMAPS (below plugins)
-- =========================
---- Window navigation (Ctrl + h/j/k/l)
vim.keymap.set("n", "<C-h>", "<C-w>h")  -- move to left split
vim.keymap.set("n", "<C-l>", "<C-w>l")  -- move to right split
vim.keymap.set("n", "<C-j>", "<C-w>j")  -- move to split below
vim.keymap.set("n", "<C-k>", "<C-w>k")  -- move to split above


vim.keymap.set("n", "<C-Right>", ":vertical resize +5<CR>")
vim.keymap.set("n", "<C-Left>", ":vertical resize -5<CR>")

-- Ctrl+C → Copy to system clipboard
vim.keymap.set("v", "<C-c>", '"+y', { desc = "Copy to system clipboard (Ctrl+C)" })

vim.keymap.set("v", "<C-x>", '"+d', { desc = "Cut to system clipboard (Ctrl+X)" })

vim.keymap.set({ "n", "v", "i" }, "<C-v>", '"+p', { desc = "Paste from system clipboard (Ctrl+V)" })

--#region-- Cmd+A → Select all
vim.keymap.set({ "n", "v" }, "<D-a>", "ggVG")
vim.keymap.set("i", "<D-a>", "<Esc>ggVG")

-- -- VS Code style commenting: Ctrl+/
vim.keymap.set("n", "<C-_>", function()
  require("Comment.api").toggle.linewise.current()
end, { desc = "Toggle comment" })

vim.keymap.set("v", "<C-_>", function()
  require("Comment.api").toggle.linewise(vim.fn.visualmode())
end, { desc = "Toggle comment (visual)" })

local map = vim.keymap.set

map("n", "<leader>tn", function()
  local next_idx = (current_theme_index % #themes) + 1
  apply_theme(next_idx)
end)

map("n", "<leader>tp", function()
  local prev_idx = current_theme_index - 1
  if prev_idx < 1 then prev_idx = #themes end
  apply_theme(prev_idx)
end)

local map = vim.keymap.set

map("v", "<C-Del>", "d")
map("v", "<D-Del>", "d")
map("n", "<C-z>", "u")
map("n", "<C-S-z>", "<C-r>")
map({ "n", "v" }, "<C-a>", "ggVG")
map("i", "<C-a>", "<Esc>ggVG")
map({ "n", "v" }, "<D-a>", "ggVG")
map("i", "<D-a>", "<Esc>ggVG")
map("n", "<C-BS>", "dd")
map("i", "<C-BS>", "<Esc>ddi")
map("n", "<D-BS>", "dd")
map("i", "<D-BS>", "<Esc>ddi")

local map = vim.keymap.set

-- Next / previous tab
map("n", "<Tab>", ":BufferLineCycleNext<CR>", { silent = true, desc = "Next tab" })
map("n", "<S-Tab>", ":BufferLineCyclePrev<CR>", { silent = true, desc = "Prev tab" })

-- Close current tab (buffer)
map("n", "<leader>bd", ":bdelete<CR>", { silent = true, desc = "Close buffer" })

-- =========================
-- AUTOSAVE
-- =========================
local autosave_group = vim.api.nvim_create_augroup("Autosave", { clear = true })

vim.api.nvim_create_autocmd({ "InsertLeave", "TextChanged", "TextChangedI" }, {
  group = autosave_group,
  callback = function()
    if vim.bo.modifiable and vim.bo.buftype == "" and vim.fn.expand("%") ~= "" then
      vim.cmd("silent write")
    end
  end,
})

