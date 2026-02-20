local function set_lsp_keymap(client, buffer)
	local map = function(keys, func, desc, mode)
		mode = mode or "n"
		vim.keymap.set(mode, keys, func, { buffer = buffer, desc = "LSP: " .. desc })
	end

	map("grn", vim.lsp.buf.rename, "[R]e[n]ame")
	map("gra", vim.lsp.buf.code_action, "[G]oto Code [A]ction", { "n", "x" })
	map("grr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
	map("gri", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")
	map("grd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
	map("grD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
	map("gO", require("telescope.builtin").lsp_document_symbols, "Open Document Symbols")
	map("gW", require("telescope.builtin").lsp_dynamic_workspace_symbols, "Open Workspace Symbols")
	map("grt", require("telescope.builtin").lsp_type_definitions, "[G]oto [T]ype Definition")

	assert(client, "lspconfig.lua: set_lsp_keymap called with invalid client")
	if client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint, buffer) then
		map("<leader>th", function()
			vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = buffer }))
		end, "[T]oggle Inlay [H]ints")
	end
end

local function configure_hover_highlighting(client, buffer)
	assert(client, "lspconfig.lua: configure_hover_highlighting called with invalid client")
	if client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight, buffer) then
		local highlight_augroup_name = "lsp-highlight"
		local highlight_augroup = vim.api.nvim_create_augroup(highlight_augroup_name, { clear = false })
		vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
			buffer = buffer,
			group = highlight_augroup,
			callback = vim.lsp.buf.document_highlight,
		})

		vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
			buffer = buffer,
			group = highlight_augroup,
			callback = vim.lsp.buf.clear_references,
		})

		vim.api.nvim_create_autocmd("LspDetach", {
			group = vim.api.nvim_create_augroup("lsp-detach", { clear = true }),
			callback = function(event)
				vim.lsp.buf.clear_references()
				vim.api.nvim_clear_autocmds({ group = highlight_augroup_name, buffer = event.buf })
			end,
		})
	end
end

local function configure_diagnostics()
	vim.diagnostic.config({
		severity_sort = true,
		float = { border = "rounded", source = "if_many" },
		underline = { severity = vim.diagnostic.severity.ERROR },
		signs = vim.g.have_nerd_font and {
			text = {
				[vim.diagnostic.severity.ERROR] = "󰅚 ",
				[vim.diagnostic.severity.WARN] = "󰀪 ",
				[vim.diagnostic.severity.INFO] = "󰋽 ",
				[vim.diagnostic.severity.HINT] = "󰌶 ",
			},
		} or {},
		virtual_text = {
			source = "if_many",
			spacing = 2,
			format = function(diagnostic)
				return diagnostic.message
			end,
		},
	})
end

return {
	"neovim/nvim-lspconfig",
	dependencies = {
		{ "j-hui/fidget.nvim", opts = {} },
		"saghen/blink.cmp",
	},
	config = function()
		configure_diagnostics()

		local capabilities = vim.lsp.protocol.make_client_capabilities();
		vim.tbl_deep_extend("force", {}, capabilities, require("blink.cmp").get_lsp_capabilities())

		local default_on_attach = function(client, buffer)
			set_lsp_keymap(client, buffer)
			configure_hover_highlighting(client, buffer)

			vim.o.foldmethod = "expr"
			vim.o.foldexpr = "v:lua.vim.lsp.foldexpr()"
			vim.o.foldtext = ""
		end

		vim.lsp.config("*", {
			capabilities = capabilities,
			on_attach = default_on_attach,
		})

		vim.lsp.config("lua_ls", {
			capabilities = capabilities,
			on_attach = default_on_attach,
			filetypes = { "lua" },
			settings = {
				Lua = {
					diagnostics = {
						globals = { "vim" },
						-- disable = { "missing-fields" },
					},
					-- completion = {
					-- 	callSnippet = "Replace",
					-- },
				},
			},
		})

		vim.lsp.config("clangd", {
			capabilities = capabilities,
			on_attach = default_on_attach,
			cmd = {
				"clangd",
				"--clang-tidy",
				"--background-index",
				"--all-scopes-completion",
				"--completion-style=detailed",
				"--malloc-trim",
				"--header-insertion-decorators",
				"--header-insertion=iwyu",
				"--cross-file-rename",
				"-j=8",
			},
			settings = {
			},
		})

		vim.lsp.enable({
			"lua_ls",
			"clangd",
			"zls",
		})
	end,
}
