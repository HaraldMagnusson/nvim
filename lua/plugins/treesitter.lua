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

		vim.api.nvim_create_autocmd("FileType", {
			callback = function(event)
				local lang = vim.treesitter.language.get_lang(event.match)
				if lang == nil then
					return
				end

				local available = ts.get_available()
				for _, available_lang in pairs(available) do
					if lang == available_lang then
						ts.install({ lang })
					end
				end
			end,
		})
	end,
}
