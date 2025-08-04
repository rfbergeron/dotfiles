--[[
	before changing options, run `:h nvim-defaults` to see if the option has
	already been set by default by nvim. some of the options in my original
	vim/neovim config are unnecessary here.
	also, remember to check out mini.nvim because some of the things in there
	are cool (for example, there's a replacement/equivalent to vim.surround)
]]

vim.opt.guicursor = {
	"n-v-c:block",
	"i-ci-ve:ver25",
	"r-cr:hor20",
	"o:hor50",
	"a:blinkwait0-blinkoff600-blinkon600-Cursor/lCursor",
	"sm:block-blinkwait0-blinkoff600-blinkon600",
}

vim.opt.showmatch = true
vim.opt.showmode = true
vim.opt.lazyredraw = true
vim.opt.magic = true
vim.opt.listchars = {
	eol = "$",
	nbsp = "+",
	tab = "<~>",
	trail = "-",
}

vim.opt.mouse = { a = true }

vim.opt.number = false
vim.opt.relativenumber = true
vim.opt.numberwidth = 3
vim.opt.wrap = true
vim.opt.showbreak = "  >"
vim.opt.signcolumn = "yes"
vim.opt.foldenable = false
vim.opt.winborder = "single"
-- showbreak in gutter
vim.opt.cpoptions:append("n")

-- set filetype for posix/bourne shell rc
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	pattern = ".shrc",
	callback = function()
		vim.bo.filetype = "sh"
	end,
})

require("nvim-treesitter.configs").setup({
	-- A list of parser names, or "all" (the listed parsers MUST always be installed)
	ensure_installed = { "cpp", "bash", "c", "lua", "markdown", "markdown_inline", "vim", "vimdoc", "rust", "python", },

	-- Install parsers synchronously (only applied to `ensure_installed`)
	sync_install = false,

	-- Automatically install missing parsers when entering buffer
	-- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
	auto_install = true,

	-- List of parsers to ignore installing (or "all")
	ignore_install = {},

	---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
	-- parser_install_dir = "/some/path/to/store/parsers", -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!

	highlight = {
		enable = true,

		-- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
		-- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
		-- the name of the parser)
		-- list of language that will be disabled
		-- disable = { "c", "rust" },
		-- Or use a function for more flexibility, e.g. to disable slow treesitter highlight for large files
		--[[
		disable = function(lang, buf)
			local max_filesize = 128 * 1024 -- 100 KB
			local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
			if ok and stats and stats.size > max_filesize then
				return true
			end
		end,
		]]

		-- Setting this to true will run `:h syntax` and tree-sitter at the same time.
		-- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
		-- Using this option may slow down your editor, and you may see some duplicate highlights.
		-- Instead of true it can also be a list of languages
		additional_vim_regex_highlighting = false,
	},

	-- lsp complains if this element is not present
	modules = {},
})

-- https://stackoverflow.com/questions/78077278/treesitter-and-syntax-folding
-- use treesitter where possible
vim.api.nvim_create_autocmd("Filetype", {
	pattern = {
		"cpp",
		"c",
		"lua",
		"markdown",
		"rust",
		"python",
	},
	callback = function()
		vim.wo.foldmethod = "expr"
		vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
		vim.bo.indentexpr = "v:lua.require('nvim_treesitter').indentexpr()"
		vim.treesitter.start()
	end,
})

-- bash and vim parsers do not handle indentation
vim.api.nvim_create_autocmd("Filetype", {
	pattern = {
		"bash",
		"vim",
		"vimdoc",
		"markdown_inline",
	},
	callback = function()
		vim.wo.foldmethod = "expr"
		vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
		vim.bo.cindent = true
		vim.treesitter.start()
	end,
})

-- indentation guides and scope outlining
require("ibl").setup()

-- Add cmp_nvim_lsp capabilities settings to lspconfig
-- This should be executed before you configure any language server
local lspconfig = require("lspconfig")
local lspconfig_defaults = lspconfig.util.default_config
lspconfig_defaults.capabilities =
    vim.tbl_deep_extend("force", lspconfig_defaults.capabilities, require("cmp_nvim_lsp").default_capabilities())

-- This is where you enable features that only work
-- if there is a language server active in the file
vim.api.nvim_create_autocmd("LspAttach", {
	desc = "LSP actions",
	callback = function(event)
		local opts = { buffer = event.buf }

		-- make some default vim bindings work better
		vim.keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>", opts)
		vim.keymap.set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>", opts)

		-- add some more gr bindings in addition to the nvim defaults
		vim.keymap.set("n", "grf", "<cmd>lua vim.lsp.buf.format({async = true})<cr>", opts)
		vim.keymap.set("n", "grI", "<cmd>lua vim.lsp.buf.incoming_calls()<cr>", opts)
		vim.keymap.set("n", "grO", "<cmd>lua vim.lsp.buf.outgoing_calls()<cr>", opts)
		vim.keymap.set("n", "grp", "<cmd>lua vim.lsp.buf.signature_help()<cr>", opts)
		vim.keymap.set("n", "grh", "<cmd>lua vim.lsp.buf.typehierarchy()<cr>", opts)
		vim.keymap.set("n", "grw", "<cmd>lua vim.lsp.buf.workspace_symbol()<cr>", opts)
		vim.keymap.set("n", "grd", "<cmd>lua vim.diagnostic.open_float()<cr>", opts)
	end,
})

-- You'll find a list of language servers here:
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md

vim.lsp.enable("ccls")
vim.lsp.enable("bashls")
vim.lsp.enable("rust_analyzer")
vim.lsp.enable("pylsp")

-- make LuaLS work nicely with neovim apis
-- NOTE: consider lazydev.nvim instead of manually specifying library paths
vim.lsp.config("lua_ls", {
	on_init = function(client)
		-- don't do this if there's a lua_ls configuration file
		if client.workspace_folders then
			local path = client.workspace_folders[1].name
			if path ~= vim.fn.stdpath('config')
			    and vim.uv.fs_stat(path .. "/.luarc.json") or vim.uv.fs_stat(path .. "/.luarc.jsonc") then
				return
			end
		end

		client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
			runtime = {
				-- Tell the language server which version of Lua you're using
				-- (most likely LuaJIT in the case of Neovim)
				version = "LuaJIT",
				-- Tell the language server how to find Lua modules same way as Neovim
				-- (see `:h lua-module-load`)
				path = {
					"lua/?.lua",
					"lua/?/init.lua",
				},
			},
			-- Make the server aware of Neovim runtime files
			workspace = {
				checkThirdParty = false,
				library = {
					vim.env.VIMRUNTIME,
					vim.fn.stdpath("config"),
					-- luvit type definitions
					vim.fn.stdpath("data") .. "/site/pack/lsp/start/luvit-meta",
					-- lsp/completion related lua plugins
					vim.fn.stdpath("data") .. "/site/pack/lsp/start/lspconfig",
					vim.fn.stdpath("data") .. "/site/pack/lsp/start/cmp",
					vim.fn.stdpath("data") .. "/site/pack/lsp/start/luasnip",
					vim.fn.stdpath("data") .. "/site/pack/lsp/start/cmp-lsp",
					vim.fn.stdpath("data") .. "/site/pack/lsp/start/cmp-luasnip",
					vim.fn.stdpath("data") .. "/site/pack/lsp/start/lsp-zero",
					-- other plugins
					vim.fn.stdpath("data") .. "/site/pack/treesitter/start/treesitter",
					vim.fn.stdpath("data") .. "/site/pack/treesitter/start/treesitter-textobjects",
					vim.fn.stdpath("data") .. "/site/pack/plugins/start/indent-blankline",
					vim.fn.stdpath("data") .. "/site/pack/plugins/start/mini",
					-- Depending on the usage, you might want to add additional paths here.
					-- "${3rd}/luv/library"
					-- "${3rd}/busted/library",
				},
				-- Or pull in all of 'runtimepath'.
				-- NOTE: this is a lot slower and will cause issues when working on
				-- your own configuration.
				-- See https://github.com/neovim/nvim-lspconfig/issues/3189
				-- library = {
				--   vim.api.nvim_get_runtime_file("", true),
				-- }
			},
		})
	end,
	on_attach = lspconfig.lua_ls.on_attach,
	capabilities = lspconfig.lua_ls.capabilities,
	settings = {
		Lua = {
			completion = {
				callSnippet = "Replace",
			},
		},
	},
})

vim.lsp.enable("lua_ls")

-- mini.nvim modules
require("mini.ai").setup()
require("mini.trailspace").setup()
require("mini.surround").setup()
require("mini.trailspace").setup()

-- set up nvim-cmp.
local cmp = require("cmp")
local luasnip = require("luasnip")

luasnip.config.setup({})

cmp.setup({
	snippet = {
		-- REQUIRED - you must specify a snippet engine
		expand = function(args)
			luasnip.lsp_expand(args.body) -- For `luasnip` users.
		end,
	},
	-- window = {
	--   -- completion = cmp.config.window.bordered(),
	--   -- documentation = cmp.config.window.bordered(),
	-- },
	mapping = cmp.mapping.preset.insert({
		["<C-b>"] = cmp.mapping.scroll_docs(-4),
		["<C-f>"] = cmp.mapping.scroll_docs(4),
		["<C-Space>"] = cmp.mapping.complete(),
		["<C-e>"] = cmp.mapping.abort(),
		["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
	}),
	sources = cmp.config.sources({
		{ name = "nvim_lsp" },
		{ name = "luasnip" },
	}),
})
