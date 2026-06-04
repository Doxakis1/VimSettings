return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",

		-- Completion
		"hrsh7th/nvim-cmp",
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-path",
		"saadparwaiz1/cmp_luasnip",
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-nvim-lua",

		-- Snippets
		"L3MON4D3/LuaSnip",
		"rafamadriz/friendly-snippets",
	},

	config = function()
		---------------------------------------------------------------------
		-- UI: Borders, diagnostics, floating windows
		---------------------------------------------------------------------
		vim.opt.signcolumn = "yes"

		local border = "rounded"

		vim.lsp.handlers["textDocument/hover"] = function(_, result, ctx, config)
			config = config or {}
			config.border = border
			return vim.lsp.handlers.hover(_, result, ctx, config)
		end

		vim.lsp.handlers["textDocument/signatureHelp"] = function(_, result, ctx, config)
			config = config or {}
			config.border = border
			return vim.lsp.handlers.signature_help(_, result, ctx, config)
		end

		vim.diagnostic.config({
			virtual_text = true,
			severity_sort = true,
			float = {
				style = "minimal",
				border = "rounded",
				source = "if_many",
				header = "",
				prefix = "",
			},
			signs = {
				text = {
					[vim.diagnostic.severity.ERROR] = "✘",
					[vim.diagnostic.severity.WARN]  = "▲",
					[vim.diagnostic.severity.HINT]  = "⚑",
					[vim.diagnostic.severity.INFO]  = "»",
				},
			},
		})

		---------------------------------------------------------------------
		-- Capabilities
		---------------------------------------------------------------------
		local capabilities = require("cmp_nvim_lsp").default_capabilities()

		---------------------------------------------------------------------
		-- Keymaps on LSP attach
		---------------------------------------------------------------------
		vim.api.nvim_create_autocmd("LspAttach", {
			callback = function(event)
				local buf = event.buf
				local client = vim.lsp.get_client_by_id(event.data.client_id)

				local map = function(mode, lhs, rhs)
					vim.keymap.set(mode, lhs, rhs, { buffer = buf })
				end

				map("n", "K", vim.lsp.buf.hover)
				map("n", "gd", vim.lsp.buf.definition)
				map("n", "gD", vim.lsp.buf.declaration)
				map("n", "gi", vim.lsp.buf.implementation)
				map("n", "go", vim.lsp.buf.type_definition)
				map("n", "gr", vim.lsp.buf.references)
				map("n", "gs", vim.lsp.buf.signature_help)
				map("n", "gl", vim.diagnostic.open_float)
				map("n", "<F2>", vim.lsp.buf.rename)
				map({ "n", "x" }, "<F3>", function()
					vim.lsp.buf.format({ async = true })
				end)
				map("n", "<F4>", vim.lsp.buf.code_action)

				-- Document highlight
				if client.server_capabilities.documentHighlightProvider then
					local group = vim.api.nvim_create_augroup("lsp-highlight", { clear = false })
					vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
						buffer = buf,
						group = group,
						callback = vim.lsp.buf.document_highlight,
					})
					vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
						buffer = buf,
						group = group,
						callback = vim.lsp.buf.clear_references,
					})
				end

				-- Format on save (except excluded)
				local excluded = { php = true, c = true, cpp = true }
				if client.server_capabilities.documentFormattingProvider
					and not excluded[vim.bo[buf].filetype]
				then
					vim.api.nvim_create_autocmd("BufWritePre", {
						buffer = buf,
						callback = function()
							vim.lsp.buf.format({ bufnr = buf, timeout_ms = 1000 })
						end,
					})
				end
			end,
		})

		---------------------------------------------------------------------
		-- Mason setup
		---------------------------------------------------------------------
		require("mason").setup()

		---------------------------------------------------------------------
		-- Mason-LSPConfig: Install all servers
		---------------------------------------------------------------------
		local servers = {
			"lua_ls",
			"cssls",
			"intelephense",
			"ts_ls",
			"zls",
			"rust_analyzer",
			"clangd",
			"serve_d",
			"jsonls",
			"gopls",
			"templ",
			"eslint",
			"pyright",
			"bashls",
		}

		require("mason-lspconfig").setup({
			ensure_installed = servers,

			handlers = {
				-----------------------------------------------------------------
				-- Default handler
				-----------------------------------------------------------------
				function(server)
					require("lspconfig")[server].setup({
						capabilities = capabilities,
					})
				end,

				-----------------------------------------------------------------
				-- Lua
				-----------------------------------------------------------------
				lua_ls = function()
					require("lspconfig").lua_ls.setup({
						capabilities = capabilities,
						settings = {
							Lua = {
								runtime = { version = "LuaJIT" },
								diagnostics = { globals = { "vim" } },
								workspace = {
									checkThirdParty = false,
									library = vim.api.nvim_get_runtime_file("", true),
								},
								telemetry = { enable = false },
							},
						},
					})
				end,

				-----------------------------------------------------------------
				-- CSS
				-----------------------------------------------------------------
				cssls = function()
					require("lspconfig").cssls.setup({
						capabilities = capabilities,
						settings = {
							css = { validate = true },
							scss = { validate = true },
							less = { validate = true },
						},
					})
				end,

				-----------------------------------------------------------------
				-- PHP
				-----------------------------------------------------------------
				intelephense = function()
					require("lspconfig").intelephense.setup({
						capabilities = capabilities,
						settings = {
							intelephense = {
								files = { maxSize = 5000000 },
							},
						},
					})
				end,

				-----------------------------------------------------------------
				-- TypeScript
				-----------------------------------------------------------------
				ts_ls = function()
					require("lspconfig").ts_ls.setup({
						capabilities = capabilities,
						settings = {
							completions = { completeFunctionCalls = true },
						},
					})
				end,

				-----------------------------------------------------------------
				-- Zig
				-----------------------------------------------------------------
				zls = function()
					require("lspconfig").zls.setup({
						capabilities = capabilities,
						settings = {
							zls = {
								enable_build_on_save = true,
								build_on_save_step = "install",
								warn_style = false,
								enable_snippets = true,
							},
						},
					})
				end,

				-----------------------------------------------------------------
				-- Rust
				-----------------------------------------------------------------
				rust_analyzer = function()
					require("lspconfig").rust_analyzer.setup({
						capabilities = capabilities,
						settings = {
							["rust-analyzer"] = {
								cargo = { allFeatures = true },
								formatting = { command = { "rustfmt" } },
							},
						},
					})
				end,

				-----------------------------------------------------------------
				-- Bash
				-----------------------------------------------------------------
				bashls = function()
					require("lspconfig").bashls.setup({
						capabilities = capabilities,
						filetypes = { "sh", "bash", "zsh" },
					})
				end,
				-----------------------------------------------------------------
				-- C/C++
				-----------------------------------------------------------------
				clangd = function()
					require("lspconfig").clangd.setup({
						capabilities = capabilities,
					})
				end,

				-----------------------------------------------------------------
				-- D
				-----------------------------------------------------------------
				serve_d = function()
					require("lspconfig").serve_d.setup({
						capabilities = capabilities,
					})
				end,

				-----------------------------------------------------------------
				-- JSON
				-----------------------------------------------------------------
				jsonls = function()
					require("lspconfig").jsonls.setup({
						capabilities = capabilities,
					})
				end,
				-----------------------------------------------------------------
				-- Go
				-----------------------------------------------------------------
				gopls = function()
					require("lspconfig").gopls.setup({
						capabilities = capabilities,
						settings = {
							gopls = {
								analyses = {
									unusedparams = false,
									ST1003 = false,
									ST1000 = false,
								},
								staticcheck = true,
							},
						},
					})
				end,

				-----------------------------------------------------------------
				-- Templ
				-----------------------------------------------------------------
				templ = function()
					require("lspconfig").templ.setup({
						capabilities = capabilities,
					})
				end,

				-----------------------------------------------------------------
				-- Python (Pyright)
				-----------------------------------------------------------------
				pyright = function()
					require("lspconfig").pyright.setup({
						capabilities = capabilities,
						settings = {
							python = {
								analysis = {
									typeCheckingMode = "basic",
									autoSearchPaths = true,
									useLibraryCodeForTypes = true,
									diagnosticMode = "workspace",
								},
							},
						},
					})
				end,
			},
		})

		---------------------------------------------------------------------
		-- nvim-cmp setup
		---------------------------------------------------------------------
		local cmp = require("cmp")
		require("luasnip.loaders.from_vscode").lazy_load()

		vim.opt.completeopt = { "menu", "menuone", "noselect" }

		cmp.setup({
			preselect = "item",
			completion = { completeopt = "menu,menuone,noinsert" },
			window = { documentation = cmp.config.window.bordered() },
			sources = {
				{ name = "path" },
				{ name = "nvim_lsp" },
				{ name = "buffer",  keyword_length = 3 },
				{ name = "luasnip", keyword_length = 2 },
			},
			snippet = {
				expand = function(args)
					require("luasnip").lsp_expand(args.body)
				end,
			},
			formatting = {
				fields = { "abbr", "menu", "kind" },
				format = function(entry, item)
					local n = entry.source.name
					item.menu = n == "nvim_lsp" and "[LSP]" or string.format("[%s]", n)
					return item
				end,
			},
			mapping = cmp.mapping.preset.insert({
				["<C-y>"] = cmp.mapping.confirm({ select = false }),
				["<C-f>"] = cmp.mapping.scroll_docs(5),
				["<C-u>"] = cmp.mapping.scroll_docs(-5),
				["<C-e>"] = cmp.mapping(function()
					if cmp.visible() then cmp.abort() else cmp.complete() end
				end),
				["<Tab>"] = cmp.mapping(function(fallback)
					local col = vim.fn.col(".") - 1
					if cmp.visible() then
						cmp.select_next_item({ behavior = "select" })
					elseif col == 0 or vim.fn.getline("."):sub(col, col):match("%s") then
						fallback()
					else
						cmp.complete()
					end
				end, { "i", "s" }),
				["<S-Tab>"] = cmp.mapping.select_prev_item({ behavior = "select" }),
				["<C-d>"] = cmp.mapping(function(fallback)
					local ls = require("luasnip")
					if ls.jumpable(1) then ls.jump(1) else fallback() end
				end, { "i", "s" }),
				["<C-b>"] = cmp.mapping(function(fallback)
					local ls = require("luasnip")
					if ls.jumpable(-1) then ls.jump(-1) else fallback() end
				end, { "i", "s" }),
			}),
		})
	end,
}
