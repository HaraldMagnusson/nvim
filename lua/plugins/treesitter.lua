return {
	"nvim-treesitter/nvim-treesitter",
	lazy = false,
	build = ":TSUpdate",
	config = function()
		local ts = require("nvim-treesitter")
		ts.install({
			"bash",
			"c",
			"cpp",
			"zig",
			"diff",
			"lua",
			"luadoc",
			"markdown",
			"markdown_inline",
			"vim",
			"vimdoc",
		})

		-- vim.api.nvim_create_autocmd("User", {
		-- 	pattern = "TSUpdate",
		-- 	callback = function()
		-- 		require("nvim-treesitter.parsers").zig = {
		-- 			tier = 2,
		-- 			url = "https://github.com/mnemnion/tree-sitter-zig",
		-- 			revision = "ca7bb74500fea656429d527a1609181882c6ea7d",
		-- 			branch = "fragment-refactor",
		-- 			queries = "queries",
		-- 		}
		-- 	end
		-- })

		local fold_levels = {}
		fold_levels["lua"] = 1

		---@param buf integer
		---@param lang string
		local function treesitter_try_attach(buf, lang)
			if not vim.treesitter.language.add(lang) then return end
			vim.treesitter.start(buf, lang)

			vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
			vim.wo.foldmethod = "expr"
			vim.wo.foldtext = ""
			vim.wo.foldlevel = fold_levels[lang] or 0

			if vim.treesitter.query.get(lang, "indents") then
				vim.bo.indentexpr = "v:lua.require('nvim-treesitter').indentexpr()"
			end
		end

		local available_parsers = ts.get_available()
		vim.api.nvim_create_autocmd("FileType", {
			callback = function(args)
				local buf, filetype = args.buf, args.match

				local lang = vim.treesitter.language.get_lang(filetype)
				if not lang then return end

				local installed_parsers = ts.get_installed("parsers")
				if vim.tbl_contains(installed_parsers, lang) then
					treesitter_try_attach(buf, lang)
				elseif vim.tbl_contains(available_parsers, lang) then
					ts.install(lang):await(function()
						treesitter_try_attach(buf, lang)
					end)
				else
					treesitter_try_attach(buf, lang)
				end
			end,
		})
	end,
}
